import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import "../theme"

Item {
    id: root
    implicitWidth: layoutText.implicitWidth + 8
    implicitHeight: 22
    property string layout: "us"
    function mapKeymap(name) {
        const n = name.toLowerCase();
        if (n.includes("english"))
            return "us";
        if (n.includes("russian"))
            return "ru";
        return n.slice(0, 2);
    }
    Process {
        id: initProc
        command: ["sh", "-c", "hyprctl devices | awk '/active keymap/{km=$0} /main: yes/{print km; exit}'"]
        running: true
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                const m = this.text.trim().match(/active keymap:\s*(.+)$/);
                if (m)
                    root.layout = root.mapKeymap(m[1]);
            }
        }
    }
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activelayout") {
                const km = event.data.split(",").pop();
                root.layout = root.mapKeymap(km);
            }
        }
    }
    Text {
        id: layoutText
        anchors.centerIn: parent
        text: root.layout
        color: Theme.subtext0
        font.family: Theme.font
        font.pointSize: 9
    }
}
