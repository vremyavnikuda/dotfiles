import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../theme"

Item {
    id: root
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    readonly property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null
    readonly property bool playing: player !== null && player.playbackState === MprisPlaybackState.Playing
    visible: player !== null
    RowLayout {
        id: row
        spacing: 6
        IconImage {
            implicitSize: 16
            source: Quickshell.iconPath(root.playing ? "media-playback-pause" : "media-playback-start", "media-playback-start")
        }
        Text {
            text: {
                const t = (root.player?.trackArtist ?? "") + " — " + (root.player?.trackTitle ?? "");
                return t.length > 32 ? t.slice(0, 32) + "…" : t;
            }
            color: Theme.subtext0
            font.family: Theme.font
            font.pointSize: 9
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: if (root.player) root.player.togglePlaying()
        onWheel: wheel => {
            if (root.player) {
                if (wheel.angleDelta.y > 0)
                    root.player.previous();
                else
                    root.player.next();
            }
        }
    }
}
