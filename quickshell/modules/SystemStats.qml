import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../theme"

RowLayout {
    id: root
    spacing: 14
    property var barScreen: null
    property real cpuUsage: 0
    property real ramUsage: 0
    property string cpuTemp: ""
    property string gpuTemp: ""
    property var prevCpu: null
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            if (!cpuProc.running) cpuProc.running = true;
            if (!memProc.running) memProc.running = true;
        }
    }
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            if (!gpuProc.running) gpuProc.running = true;
            if (!tempProc.running) tempProc.running = true;
        }
    }
    Process {
        id: cpuProc
        command: ["cat", "/proc/stat"]
        running: true
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                const p = this.text.split("\n")[0].trim().split(/\s+/).slice(1).map(Number);
                const work = p[0] + p[1] + p[2] + p[5] + p[6] + p[7];
                const total = work + p[3] + p[4];
                if (root.prevCpu) {
                    const dw = work - root.prevCpu.work;
                    const dt = total - root.prevCpu.total;
                    if (dt > 0)
                        root.cpuUsage = dw / dt * 100;
                }
                root.prevCpu = { work: work, total: total };
            }
        }
    }
    Process {
        id: memProc
        command: ["cat", "/proc/meminfo"]
        running: true
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                const t = this.text.match(/MemTotal:\s+(\d+)/);
                const a = this.text.match(/MemAvailable:\s+(\d+)/);
                if (t && a)
                    root.ramUsage = (1 - Number(a[1]) / Number(t[1])) * 100;
            }
        }
    }
    // CPU temp via lm_sensors (chip hides itself if sensors is missing)
    Process {
        id: tempProc
        command: ["sh", "-c", "sensors 2>/dev/null | grep -m1 -E 'Tctl|Package id' | grep -oP '\\+\\K[0-9]+'"]
        running: true
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: root.cpuTemp = this.text.trim()
        }
    }

    // GPU temp via nvidia-smi (read-only query)
    Process {
        id: gpuProc
        command: ["nvidia-smi", "--query-gpu=temperature.gpu", "--format=csv,noheader,nounits"]
        running: true
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: root.gpuTemp = this.text.trim()
        }
    }
    StatChip {
        icon: "cpu"
        text: Math.round(root.cpuUsage) + "%"
        textColor: root.cpuUsage > 85 ? Theme.red : Theme.text
    }
    StatChip {
        icon: "memory"
        text: Math.round(root.ramUsage) + "%"
        textColor: root.ramUsage > 90 ? Theme.red : Theme.text
    }
    StatChip {
        visible: root.cpuTemp !== ""
        icon: "temperature-normal"
        text: root.cpuTemp + "°"
    }
    StatChip {
        visible: root.gpuTemp !== ""
        icon: "nvidia"
        text: root.gpuTemp + "°"
    }
    MouseArea {
        anchors.fill: parent
        onClicked: sysInfo.visible ? sysInfo.close() : sysInfo.open()
    }
    SystemInfo {
        id: sysInfo
        barScreen: root.barScreen
    }
}
