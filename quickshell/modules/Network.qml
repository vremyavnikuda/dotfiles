import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../theme"

Item {
    id: root
    property var barScreen: null
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    property bool online: false
    property bool wifi: false
    property string connName: ""
    property int signal: 0
    function signalIcon() {
        if (!root.online)
            return "network-offline";
        if (!root.wifi)
            return "network-wired";
        if (root.signal > 80)
            return "network-wireless-signal-excellent";
        if (root.signal > 55)
            return "network-wireless-signal-good";
        if (root.signal > 30)
            return "network-wireless-signal-ok";
        return "network-wireless-signal-weak";
    }
    Process {
        id: probe
        command: ["nmcli", "-t", "-f", "NAME,TYPE", "connection", "show", "--active"]
        running: true
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                const lines = this.text.trim().split("\n").filter(l => l.length > 0);
                if (lines.length === 0) {
                    root.online = false;
                    root.connName = "";
                    root.wifi = false;
                } else {
                    root.online = true;
                    const parts = lines[0].split(":");
                    if (!root.wifi)
                        root.connName = parts[0];
                    root.wifi = parts.slice(1).join(":").includes("wireless");
                }
            }
        }
    }
    Process {
        id: wifiProbe
        command: ["sh", "-c", "nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi 2>/dev/null | grep '^yes' | head -1"]
        running: true
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                const line = this.text.trim();
                if (line) {
                    const p = line.split(":");
                    root.connName = p[1] ?? root.connName;
                    root.signal = parseInt(p[2] ?? "0");
                }
            }
        }
    }
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            if (!probe.running) probe.running = true;
            if (!wifiProbe.running) wifiProbe.running = true;
        }
    }
    RowLayout {
        id: row
        spacing: 6
        IconImage {
            implicitSize: 18
            source: Quickshell.iconPath(root.signalIcon(), "network-offline")
        }
        Text {
            visible: root.online && root.wifi
            text: root.connName
            color: Theme.text
            font.family: Theme.font
            font.pointSize: 9
        }
        Text {
            visible: !root.online
            text: "offline"
            color: Theme.overlay0
            font.family: Theme.font
            font.pointSize: 9
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: netPopup.visible ? netPopup.close() : netPopup.open()
    }
    NetworkPopup {
        id: netPopup
        barScreen: root.barScreen
    }
}
