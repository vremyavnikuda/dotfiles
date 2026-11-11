import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"
PanelWindow {
    id: popup
    property var barScreen: null
    property bool wifiEnabled: true
    property var networks: []
    property string pendingSsid: ""
    property string pendingPassword: ""
    property bool wired: false
    property string wiredIp: ""
    property string wiredGw: ""
    property string wiredDns: ""
    function open() {
        visible = true;
        radioProc.running = true;
        rescanProc.running = true;
        connProc.running = true;
    }
    function close() {
        visible = false;
        pendingSsid = "";
        pendingPassword = "";
    }
    screen: barScreen
    anchors {
        top: true
        right: true
    }
    margins {
        top: Theme.barHeight + 8
        right: 12
    }
    implicitWidth: 340
    implicitHeight: mainCol.implicitHeight + 24
    visible: false
    color: "transparent"
    focusable: true
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell:netpopup"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    Process {
        id: radioProc
        command: ["nmcli", "-t", "radio", "wifi"]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: popup.wifiEnabled = this.text.trim() === "enabled"
        }
    }
    Process {
        id: radioSetProc
        command: ["nmcli", "radio", "wifi", popup.wifiEnabled ? "off" : "on"]
        onExited: {
            radioProc.running = true;
            if (popup.wifiEnabled) rescanProc.running = true;
        }
    }
    Process {
        id: listProc
        command: ["nmcli", "-t", "-f", "IN-USE,SSID,SIGNAL,SECURITY", "dev", "wifi"]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                popup.networks = this.text.trim().split("\n").filter(l => l.length > 0).map(line => {
                    const p = line.split(":");
                    return {
                        inUse: p[0] === "*",
                        ssid: p[1] ?? "",
                        signal: parseInt(p[2] ?? "0"),
                        secured: (p[3] ?? "") !== "" && p[3] !== "--"
                    };
                }).filter(n => n.ssid.length > 0);
            }
        }
    }
    Process {
        id: rescanProc
        command: ["nmcli", "dev", "wifi", "rescan"]
        onExited: listProc.running = true
    }
    Process {
        id: connectProc
        property string ssid: ""
        property string password: ""
        command: password.length > 0
            ? ["nmcli", "dev", "wifi", "connect", ssid, "password", password]
            : ["nmcli", "dev", "wifi", "connect", ssid]
        onExited: {
            popup.pendingSsid = "";
            popup.pendingPassword = "";
            rescanProc.running = true;
        }
    }
    Process {
        id: connProc
        command: ["sh", "-c", "nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep -v '^lo:' | head -1"]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                const line = this.text.trim();
                if (!line) {
                    popup.wired = false;
                    return;
                }
                const p = line.split(":");
                const type = p.slice(1, -1).join(":");
                popup.wired = !type.includes("wireless");
                if (popup.wired) {
                    ipProc.device = p[p.length - 1];
                    ipProc.running = true;
                }
            }
        }
    }
    Process {
        id: ipProc
        property string device: ""
        command: ["sh", "-c", "nmcli -t -f IP4.ADDRESS,IP4.GATEWAY,IP4.DNS device show " + device]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                const t = this.text;
                const ip = t.match(/IP4\.ADDRESS\[\d+\]:\s*([^\s/]+)/);
                const gw = t.match(/IP4\.GATEWAY:\s*(\S+)/);
                const dns = t.match(/IP4\.DNS\[\d+\]:\s*(\S+)/);
                popup.wiredIp = ip ? ip[1] : "—";
                popup.wiredGw = gw ? gw[1] : "—";
                popup.wiredDns = dns ? dns[1] : "—";
            }
        }
    }
    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Theme.base
        border.color: Theme.surface1
        border.width: 1
        focus: true
        Keys.onEscapePressed: popup.close()
        ColumnLayout {
            id: mainCol
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10
            Rectangle {
                Layout.fillWidth: true
                visible: popup.wired
                height: wiredCol.implicitHeight + 16
                radius: 8
                color: Theme.surface0
                ColumnLayout {
                    id: wiredCol
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 3
                    RowLayout {
                        spacing: 8
                        IconImage {
                            implicitSize: 16
                            source: Quickshell.iconPath("network-wired", "network-wired")
                        }
                        Text {
                            text: "Проводное — подключено"
                            color: Theme.text
                            font.family: Theme.font
                            font.pointSize: 9
                            font.bold: true
                        }
                    }
                    Text { text: "IP: " + popup.wiredIp; color: Theme.subtext0; font.family: Theme.font; font.pointSize: 8 }
                    Text { text: "Шлюз: " + popup.wiredGw; color: Theme.subtext0; font.family: Theme.font; font.pointSize: 8 }
                    Text { text: "DNS: " + popup.wiredDns; color: Theme.subtext0; font.family: Theme.font; font.pointSize: 8 }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 36
                radius: 8
                color: Theme.surface0
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 10
                    IconImage {
                        implicitSize: 18
                        source: Quickshell.iconPath("network-wireless", "network-wireless")
                    }
                    Text {
                        Layout.fillWidth: true
                        text: "Wi-Fi"
                        color: Theme.text
                        font.family: Theme.font
                        font.pointSize: 10
                    }
                    Switch {
                        checked: popup.wifiEnabled
                        onToggled: radioSetProc.running = true
                    }
                }
            }
            ListView {
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(contentHeight, 260)
                clip: true
                visible: popup.wifiEnabled
                model: popup.networks
                delegate: Rectangle {
                    required property var modelData
                    width: ListView.view.width
                    height: 34
                    radius: 6
                    color: modelData.inUse ? Theme.surface0 : "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        spacing: 8
                        IconImage {
                            implicitSize: 16
                            source: Quickshell.iconPath(
                                modelData.signal > 80 ? "network-wireless-signal-excellent" :
                                modelData.signal > 55 ? "network-wireless-signal-good" :
                                modelData.signal > 30 ? "network-wireless-signal-ok" :
                                "network-wireless-signal-weak",
                                "network-wireless")
                        }
                        Text {
                            Layout.fillWidth: true
                            text: modelData.ssid
                            color: modelData.inUse ? Theme.lavender : Theme.text
                            font.family: Theme.font
                            font.pointSize: 9
                            elide: Text.ElideRight
                        }
                        IconImage {
                            implicitSize: 14
                            visible: modelData.secured
                            source: Quickshell.iconPath("channel-secure", "channel-secure")
                        }
                        Text {
                            visible: modelData.inUse
                            text: "подключено"
                            color: Theme.lavender
                            font.family: Theme.font
                            font.pointSize: 8
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        enabled: !modelData.inUse
                        onClicked: {
                            if (modelData.secured) {
                                popup.pendingSsid = modelData.ssid;
                                popup.pendingPassword = "";
                                pwdField.text = "";
                                pwdField.forceActiveFocus();
                            } else {
                                connectProc.ssid = modelData.ssid;
                                connectProc.password = "";
                                connectProc.running = true;
                            }
                        }
                    }
                }
            }
            Text {
                Layout.fillWidth: true
                visible: popup.wifiEnabled && popup.networks.length === 0
                text: "Сети не найдены (или нет Wi-Fi адаптера)"
                color: Theme.overlay0
                font.family: Theme.font
                font.pointSize: 9
            }
            ColumnLayout {
                Layout.fillWidth: true
                visible: popup.pendingSsid !== ""
                spacing: 6
                Text {
                    text: "Пароль для «" + popup.pendingSsid + "»:"
                    color: Theme.subtext0
                    font.family: Theme.font
                    font.pointSize: 9
                }
                TextField {
                    id: pwdField
                    Layout.fillWidth: true
                    echoMode: TextInput.Password
                    placeholderText: "Пароль…"
                    placeholderTextColor: Theme.overlay0
                    color: Theme.text
                    font.family: Theme.font
                    font.pointSize: 10
                    background: Rectangle {
                        radius: 6
                        color: Theme.surface0
                        border.color: Theme.surface1
                    }
                    onTextChanged: popup.pendingPassword = text
                    Keys.onEscapePressed: popup.pendingSsid = ""
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Rectangle {
                        Layout.fillWidth: true
                        height: 30
                        radius: 6
                        color: connectMa.containsMouse ? Theme.blue : Theme.lavender
                        Text {
                            anchors.centerIn: parent
                            text: "Подключиться"
                            color: Theme.crust
                            font.family: Theme.font
                            font.pointSize: 9
                        }
                        MouseArea {
                            id: connectMa
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                connectProc.ssid = popup.pendingSsid;
                                connectProc.password = popup.pendingPassword;
                                connectProc.running = true;
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        height: 30
                        radius: 6
                        color: cancelMa.containsMouse ? Theme.surface1 : Theme.surface0
                        Text {
                            anchors.centerIn: parent
                            text: "Отмена"
                            color: Theme.text
                            font.family: Theme.font
                            font.pointSize: 9
                        }
                        MouseArea {
                            id: cancelMa
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: popup.pendingSsid = ""
                        }
                    }
                }
            }
        }
    }
}
