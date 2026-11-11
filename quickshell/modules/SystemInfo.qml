import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../theme"

PanelWindow {
    id: info
    property var barScreen: null
    property string kernel: ""
    property string uptime: ""
    property string cpuModel: ""
    property string cores: ""
    property string ramTotal: ""
    property string ramUsed: ""
    property string diskTotal: ""
    property string diskUsed: ""
    property string diskAvail: ""
    property int diskPct: 0
    property string gpuName: ""
    function open() {
        visible = true;
        sysProc.running = true;
    }
    function close() {
        visible = false;
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
    implicitWidth: 380
    implicitHeight: infoCol.implicitHeight + 24
    visible: false
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    focusable: true
    WlrLayershell.namespace: "quickshell:sysinfo"
    Process {
        id: sysProc
        command: ["sh", "-c", "echo \"KERNEL=$(uname -r)\"; echo \"UPTIME=$(uptime -p)\"; grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | sed 's/^ //'; echo \"CORES=$(nproc)\"; free -g | awk '/Mem:/{print \"RAMT=\" $2, \"RAMU=\" $3}'; df -BG / | awk 'NR==2{print \"DISKT=\" $2, \"DISKU=\" $3, \"DISKA=\" $4, \"DISKP=\" $5}'; nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null"]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                const t = this.text;
                const grab = (re) => { const m = t.match(re); return m ? m[1] : ""; };
                info.kernel = grab(/KERNEL=(.+)/);
                info.uptime = grab(/UPTIME=(.+)/);
                info.cpuModel = grab(/model name.*\n?/) ? t.split("\n").find(l => l.includes("Ryzen") || l.includes("Intel") || l.includes("AMD")) ?? "" : "";
                info.cores = grab(/CORES=(\d+)/);
                info.ramTotal = grab(/RAMT=(\d+)/);
                info.ramUsed = grab(/RAMU=(\d+)/);
                info.diskTotal = grab(/DISKT=(\S+)/);
                info.diskUsed = grab(/DISKU=(\S+)/);
                info.diskAvail = grab(/DISKA=(\S+)/);
                info.diskPct = parseInt(grab(/DISKP=(\d+)/)) || 0;
                const gpuLine = t.split("\n").find(l => l.length > 0 && !l.includes("=") && !l.includes("Ryzen") && !l.includes("Intel") && !l.includes("AMD"));
                info.gpuName = gpuLine ?? "";
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
        Keys.onEscapePressed: info.close()
        ColumnLayout {
            id: infoCol
            anchors.fill: parent
            anchors.margins: 14
            spacing: 8
            Text {
                Layout.fillWidth: true
                text: "Система"
                color: Theme.lavender
                font.family: Theme.font
                font.pointSize: 10
                font.bold: true
            }
            Text { text: "Arch Linux · ядро " + info.kernel; color: Theme.text; font.family: Theme.font; font.pointSize: 9 }
            Text { text: "Аптайм: " + info.uptime; color: Theme.subtext0; font.family: Theme.font; font.pointSize: 8 }
            Text { text: "Hyprland (Wayland)"; color: Theme.subtext0; font.family: Theme.font; font.pointSize: 8 }
            Text {
                Layout.fillWidth: true
                Layout.topMargin: 6
                text: "Железо"
                color: Theme.lavender
                font.family: Theme.font
                font.pointSize: 10
                font.bold: true
            }
            Text { text: info.cpuModel; color: Theme.text; font.family: Theme.font; font.pointSize: 9; elide: Text.ElideRight; Layout.fillWidth: true }
            Text { text: "Ядер: " + info.cores; color: Theme.subtext0; font.family: Theme.font; font.pointSize: 8 }
            Text { text: "RAM: " + info.ramUsed + " ГБ / " + info.ramTotal + " ГБ"; color: Theme.subtext0; font.family: Theme.font; font.pointSize: 8 }
            Text {
                visible: info.gpuName !== ""
                text: "GPU: " + info.gpuName
                color: Theme.subtext0
                font.family: Theme.font
                font.pointSize: 8
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
            Text {
                Layout.fillWidth: true
                Layout.topMargin: 6
                text: "Диск /"
                color: Theme.lavender
                font.family: Theme.font
                font.pointSize: 10
                font.bold: true
            }
            Text { text: info.diskUsed + " занято из " + info.diskTotal + " (свободно " + info.diskAvail + ")"; color: Theme.subtext0; font.family: Theme.font; font.pointSize: 8 }
            Rectangle {
                Layout.fillWidth: true
                height: 8
                radius: 4
                color: Theme.surface0
                Rectangle {
                    height: parent.height
                    radius: 4
                    color: info.diskPct > 85 ? Theme.red : Theme.lavender
                    width: parent.width * Math.min(1, info.diskPct / 100)
                }
            }
        }
    }
}
