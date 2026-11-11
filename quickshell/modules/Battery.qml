import Quickshell
import Quickshell.Services.UPower
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../theme"

Item {
    id: root
    visible: UPower.displayDevice?.isPresent ?? false
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    readonly property var dev: UPower.displayDevice
    readonly property real pct: dev?.percentage ?? 0
    RowLayout {
        id: row
        spacing: 6
        IconImage {
            implicitSize: 18
            source: Quickshell.iconPath(root.dev?.iconName ?? "battery", "battery")
        }
        Text {
            text: Math.round(root.pct) + "%"
            color: root.pct < 20 ? Theme.red : Theme.text
            font.family: Theme.font
            font.pointSize: 9
        }
    }
}
