import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../theme"

Item {
    id: root
    property var screen
    property var notifications: []
    function push(n) {
        n.tracked = true;
        root.notifications = [...root.notifications, n];
    }
    function remove(n, dismiss) {
        root.notifications = root.notifications.filter(x => x !== n);
        if (dismiss)
            n.dismiss();
        else
            n.expire();
    }
    NotificationServer {
        onNotification: n => root.push(n)
    }
    PanelWindow {
        id: popupWindow
        screen: root.screen
        anchors {
            top: true
            right: true
        }
        margins {
            top: Theme.barHeight + 12
            right: 12
        }
        implicitWidth: 380
        implicitHeight: notifCol.implicitHeight + 24
        visible: root.notifications.length > 0
        color: "transparent"
        focusable: false
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "quickshell:notifications"
        ColumnLayout {
            id: notifCol
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 12
            }
            spacing: 10
            Repeater {
                model: root.notifications
                delegate: Rectangle {
                    id: notifRect
                    required property var modelData
                    readonly property int timeoutMs: modelData.expireTimeout === -2 ? 0 : modelData.expireTimeout > 0 ? modelData.expireTimeout * 1000 : 5000
                    Layout.fillWidth: true
                    height: col.implicitHeight + 20
                    radius: 12
                    color: Theme.base
                    border.color: modelData.urgency === NotificationUrgency.Critical ? Theme.red : Theme.surface1
                    border.width: 1
                    Timer {
                        interval: Math.max(1000, notifRect.timeoutMs)
                        running: notifRect.timeoutMs > 0
                        onTriggered: root.remove(modelData, false)
                    }
                    ColumnLayout {
                        id: col
                        anchors {
                            fill: parent
                            margins: 10
                        }
                        spacing: 4
                        RowLayout {
                            spacing: 8
                            IconImage {
                                implicitSize: 20
                                source: Quickshell.iconPath(modelData.appIcon, "dialog-information")
                            }
                            Text {
                                Layout.fillWidth: true
                                text: modelData.summary
                                color: Theme.text
                                font.family: Theme.font
                                font.bold: true
                                font.pointSize: 10
                                elide: Text.ElideRight
                            }
                            Text {
                                text: "✕"
                                color: Theme.overlay0
                                font.family: Theme.font
                                font.pointSize: 10
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: root.remove(modelData, true)
                                }
                            }
                        }
                        Text {
                            Layout.fillWidth: true
                            text: modelData.body
                            color: Theme.subtext0
                            font.family: Theme.font
                            font.pointSize: 9
                            wrapMode: Text.Wrap
                            visible: text.length > 0
                        }
                        Image {
                            Layout.fillWidth: true
                            Layout.preferredHeight: visible ? 140 : 0
                            visible: (modelData.image ?? "") !== ""
                            source: modelData.image ?? ""
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.remove(modelData, true)
                    }
                }
            }
        }
    }
}
