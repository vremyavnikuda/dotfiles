import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../theme"

RowLayout {
    id: chip
    property string icon: ""
    property string text: ""
    property color textColor: Theme.text
    spacing: 5
    IconImage {
        implicitSize: 16
        source: Quickshell.iconPath(chip.icon, "dialog-information")
    }
    Text {
        text: chip.text
        color: chip.textColor
        font.family: Theme.font
        font.pointSize: 9
    }
}
