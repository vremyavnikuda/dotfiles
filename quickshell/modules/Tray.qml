import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../theme"

RowLayout {
    spacing: 8
    Repeater {
        model: SystemTray.items
        delegate: MouseArea {
            id: trayItem
            required property var modelData
            implicitWidth: 22
            implicitHeight: 22
            hoverEnabled: true
            IconImage {
                anchors.centerIn: parent
                implicitSize: 18
                source: trayItem.modelData.icon
            }
            onClicked: event => {
                const item = trayItem.modelData;
                if (item.hasMenu && (item.onlyMenu || event.button === Qt.RightButton)) {
                    const pos = trayItem.mapToItem(null, 0, trayItem.height);
                    item.display(trayItem.Window.window, pos.x, pos.y);
                } else {
                    item.activate();
                }
            }
        }
    }
}
