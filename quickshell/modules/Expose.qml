import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../theme"

PanelWindow {
    id: expose
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
    function toggle() {
        visible = !visible;
    }
    function focusWindow(addr) {
        Hyprland.dispatch(`hl.dsp.focus({window = "address:${addr}"})`);
        expose.visible = false;
    }
    readonly property var workspaces: Hyprland.workspaces.values.filter(w => w.id >= 0)
    screen: focusedScreen
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    visible: false
    color: "transparent"
    focusable: true
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell:expose"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    Rectangle {
        anchors.fill: parent
        color: "#dd11111b"
        focus: true
        Keys.onEscapePressed: expose.visible = false
        MouseArea {
            anchors.fill: parent
            onClicked: expose.visible = false
        }
        Flow {
            anchors.centerIn: parent
            width: Math.min(parent.width - 80, 1400)
            spacing: 16
            Repeater {
                model: expose.workspaces
                delegate: Rectangle {
                    id: wsCard
                    required property var modelData
                    width: 320
                    height: wsCol.implicitHeight + 20
                    radius: 8
                    color: Theme.base
                    border.color: modelData.focused ? Theme.lavender : Theme.surface1
                    border.width: 1
                    readonly property var windows: modelData.toplevels?.values ?? []
                    ColumnLayout {
                        id: wsCol
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 4
                        Text {
                            Layout.fillWidth: true
                            text: "Воркспейс " + modelData.name + " — " + wsCard.windows.length + " ок."
                            color: modelData.focused ? Theme.lavender : Theme.subtext0
                            font.family: Theme.font
                            font.pointSize: 9
                            font.bold: true
                        }
                        Repeater {
                            model: wsCard.windows
                            delegate: Rectangle {
                                id: winRow
                                required property var modelData
                                Layout.fillWidth: true
                                height: 34
                                radius: 6
                                color: rowMa.containsMouse ? Theme.surface0 : "transparent"
                                readonly property string winClass: modelData.lastIpcObject?.class ?? ""
                                readonly property var entry: DesktopEntries.heuristicLookup(winClass)
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 8
                                    spacing: 8
                                    IconImage {
                                        implicitSize: 18
                                        source: Quickshell.iconPath(winRow.entry?.icon ?? "application-x-executable", "application-x-executable")
                                    }
                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.title ?? ""
                                        color: Theme.text
                                        font.family: Theme.font
                                        font.pointSize: 9
                                        elide: Text.ElideRight
                                    }
                                }
                                MouseArea {
                                    id: rowMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: expose.focusWindow(modelData.address)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    IpcHandler {
        target: "expose"
        function toggle(): void {
            expose.toggle();
        }
    }
}
