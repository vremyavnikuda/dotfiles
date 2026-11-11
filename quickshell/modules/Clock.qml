import QtQuick
import QtQuick.Layouts
import "../theme"

Item {
    id: root
    property var barScreen: null
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    property var now: new Date()
    readonly property var months: ["янв", "фев", "мар", "апр", "мая", "июн", "июл", "авг", "сен", "окт", "ноя", "дек"]
    readonly property var days: ["вс", "пн", "вт", "ср", "чт", "пт", "сб"]
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }
    RowLayout {
        id: row
        spacing: 8
        Text {
            text: Qt.formatTime(root.now, "HH:mm")
            color: Theme.text
            font.family: Theme.font
            font.pointSize: 10
        }
        Text {
            text: {
                const d = root.now;
                return `${root.days[d.getDay()]}, ${d.getDate()} ${root.months[d.getMonth()]}`;
            }
            color: Theme.subtext0
            font.family: Theme.font
            font.pointSize: 9
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: calPopup.visible ? calPopup.close() : calPopup.open()
    }
    CalendarPopup {
        id: calPopup
        barScreen: root.barScreen
    }
}
