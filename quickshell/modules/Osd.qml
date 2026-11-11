import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../theme"

Item {
    id: root
    property bool ready: false
    property string mode: "" // "volume" | "brightness"
    property string brightPct: ""
    property var focusedScreen: {
        const fm = Hyprland.focusedMonitor;
        if (!fm)
            return null;
        for (const s of Quickshell.screens) {
            if (s.name === fm.name)
                return s;
        }
        return null;
    }
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real vol: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    PwObjectTracker {
        objects: [root.sink]
    }
    onVolChanged: if (root.ready && root.mode !== "brightness") root.show("volume")
    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.mode = ""
    }
    function show(m) {
        root.mode = m;
        hideTimer.restart();
    }
    Process {
        id: brightProc
        command: ["sh", "-c", "brightnessctl | sed -n 's/.*(\\([0-9]\\+\\)%).*/\\1/p' | head -1"]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                const v = this.text.trim();
                if (v) {
                    root.brightPct = v;
                    root.show("brightness");
                }
            }
        }
    }
    Component.onCompleted: root.ready = true
    PanelWindow {
        screen: root.focusedScreen
        anchors {
            bottom: true
        }
        margins {
            bottom: 80
        }
        implicitWidth: 280
        implicitHeight: 60
        visible: root.mode !== ""
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "quickshell:osd"
        Rectangle {
            anchors.fill: parent
            radius: 12
            color: Theme.base
            border.color: Theme.surface1
            border.width: 1
            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 12
                IconImage {
                    implicitSize: 22
                    source: Quickshell.iconPath(
                        root.mode === "brightness" ? "display-brightness" :
                        root.muted ? "audio-volume-muted" :
                        root.vol > 0.66 ? "audio-volume-high" :
                        root.vol > 0.33 ? "audio-volume-medium" : "audio-volume-low",
                        "audio-volume-high")
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 8
                    radius: 4
                    color: Theme.surface0
                    Rectangle {
                        height: parent.height
                        radius: 4
                        color: Theme.lavender
                        width: parent.width * Math.min(1, root.mode === "brightness" ? (parseInt(root.brightPct) / 100) : root.vol)
                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                            }
                        }
                    }
                }
                Text {
                    text: root.mode === "brightness" ? root.brightPct + "%" : Math.round(root.vol * 100) + "%"
                    color: Theme.text
                    font.family: Theme.font
                    font.pointSize: 10
                }
            }
        }
    }
    IpcHandler {
        target: "osd"
        function brightness(): void {
            root.show("brightness");
            brightProc.running = true;
        }
    }
}
