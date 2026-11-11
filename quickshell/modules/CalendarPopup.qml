import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../theme"

PanelWindow {
    id: cal
    property var barScreen: null
    property int viewYear: new Date().getFullYear()
    property int viewMonth: new Date().getMonth() // 0-11
    readonly property var today: new Date()
    readonly property var monthNames: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    readonly property var dayNames: ["пн", "вт", "ср", "чт", "пт", "сб", "вс"]
    function open() {
        viewYear = today.getFullYear();
        viewMonth = today.getMonth();
        visible = true;
    }
    function close() {
        visible = false;
    }
    function shiftMonth(delta) {
        let m = viewMonth + delta;
        let y = viewYear;
        if (m < 0) { m = 11; y -= 1; }
        if (m > 11) { m = 0; y += 1; }
        viewMonth = m;
        viewYear = y;
    }
    readonly property var cells: {
        const first = new Date(viewYear, viewMonth, 1);
        const startWeekday = (first.getDay() + 6) % 7; // понедельник = 0
        const daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate();
        const daysInPrev = new Date(viewYear, viewMonth, 0).getDate();
        const result = [];
        for (let i = 0; i < 42; i++) {
            const dayNum = i - startWeekday + 1;
            let d = dayNum, inMonth = true;
            if (dayNum < 1) { d = daysInPrev + dayNum; inMonth = false; }
            else if (dayNum > daysInMonth) { d = dayNum - daysInMonth; inMonth = false; }
            const isToday = inMonth
                && viewYear === today.getFullYear()
                && viewMonth === today.getMonth()
                && d === today.getDate();
            result.push({ day: d, inMonth: inMonth, isToday: isToday });
        }
        return result;
    }
    screen: barScreen
    anchors {
        top: true
    }
    margins {
        top: Theme.barHeight + 8
    }
    implicitWidth: 320
    implicitHeight: calCol.implicitHeight + 24
    visible: false
    color: "transparent"
    focusable: true
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell:calendar"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Theme.base
        border.color: Theme.surface1
        border.width: 1
        focus: true
        Keys.onEscapePressed: cal.close()
        ColumnLayout {
            id: calCol
            anchors.fill: parent
            anchors.margins: 14
            spacing: 10
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Rectangle {
                    width: 28
                    height: 28
                    radius: 6
                    color: prevMa.containsMouse ? Theme.surface0 : "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: "‹"
                        color: Theme.text
                        font.family: Theme.font
                        font.pointSize: 12
                    }
                    MouseArea {
                        id: prevMa
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: cal.shiftMonth(-1)
                    }
                }

                Text {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: cal.monthNames[cal.viewMonth] + " " + cal.viewYear
                    color: Theme.text
                    font.family: Theme.font
                    font.pointSize: 11
                    font.bold: true
                }

                Rectangle {
                    width: 28
                    height: 28
                    radius: 6
                    color: nextMa.containsMouse ? Theme.surface0 : "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: "›"
                        color: Theme.text
                        font.family: Theme.font
                        font.pointSize: 12
                    }
                    MouseArea {
                        id: nextMa
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: cal.shiftMonth(1)
                    }
                }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: 0
                Repeater {
                    model: cal.dayNames
                    Text {
                        required property string modelData
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        text: modelData
                        color: Theme.overlay0
                        font.family: Theme.font
                        font.pointSize: 8
                    }
                }
            }
            GridLayout {
                Layout.fillWidth: true
                columns: 7
                rowSpacing: 2
                columnSpacing: 0
                Repeater {
                    model: cal.cells
                    Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.preferredHeight: 32
                        radius: 6
                        color: modelData.isToday ? Theme.lavender : "transparent"
                        Text {
                            anchors.centerIn: parent
                            text: modelData.day
                            color: modelData.isToday ? Theme.crust
                                 : modelData.inMonth ? Theme.text : Theme.overlay0
                            font.family: Theme.font
                            font.pointSize: 9
                            font.bold: modelData.isToday
                        }
                    }
                }
            }
        }
    }
}
