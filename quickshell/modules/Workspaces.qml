import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../theme"

RowLayout {
    id: root
    spacing: 6
    function wsIdForIndex(i) {
        return i === 9 ? 10 : i + 1;
    }
    function findWorkspace(id) {
        const values = Hyprland.workspaces.values;
        for (let i = 0; i < values.length; i++) {
            if (values[i].id === id)
                return values[i];
        }
        return null;
    }
    WorkspaceMenu {
        id: wsMenu
        barScreen: root.barScreen
    }
    property var barScreen: null
    Repeater {
        model: 10
        delegate: Rectangle {
            required property int index
            readonly property int wsId: root.wsIdForIndex(index)
            readonly property var workspace: root.findWorkspace(wsId)
            readonly property bool occupied: workspace !== null
            readonly property bool active: workspace !== null && workspace.focused
            width: 24
            height: 22
            radius: 0
            color: active ? Theme.lavender : "transparent"
            border.width: 1
            border.color: occupied ? Theme.surface1 : "transparent"
            Text {
                anchors.centerIn: parent
                text: index === 9 ? "0" : String(index + 1)
                color: active ? Theme.crust : occupied ? Theme.text : Theme.overlay0
                font.family: Theme.font
                font.pointSize: 9
            }
            Timer {
                id: hoverTimer
                interval: 350
                onTriggered: if (parent.workspace) wsMenu.showFor(parent.workspace)
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: if (parent.workspace) hoverTimer.restart()
                onExited: {
                    hoverTimer.stop();
                    wsMenu.scheduleHide();
                }
                onClicked: Hyprland.dispatch(`hl.dsp.focus({workspace = ${parent.wsId}})`)
            }
        }
    }
}
