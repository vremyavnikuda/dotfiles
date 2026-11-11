import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../theme"

Item {
    id: root
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real vol: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    PwObjectTracker {
        objects: [root.sink]
    }
    RowLayout {
        id: row
        spacing: 6
        IconImage {
            implicitSize: 18
            source: Quickshell.iconPath(root.muted ? "audio-volume-muted" : root.vol > 0.66 ? "audio-volume-high" : root.vol > 0.33 ? "audio-volume-medium" : "audio-volume-low", "audio-volume-high")
        }
        Text {
            text: root.muted ? "—" : Math.round(root.vol * 100) + "%"
            color: root.muted ? Theme.red : Theme.text
            font.family: Theme.font
            font.pointSize: 9
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["pavucontrol"])
        onWheel: wheel => {
            if (root.sink?.audio) {
                const step = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
                root.sink.audio.volume = Math.max(0, Math.min(1.5, root.sink.audio.volume + step));
            }
        }
    }
}
