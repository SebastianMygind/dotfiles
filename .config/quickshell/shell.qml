import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Scope {
    id: root
    property string time

    property color colBg: "#1a1b26"
    property color colFg: "#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCyan: "#0db9d7"
    property color colPurple: "#ad8ee6"
    property color colRed: "#f7768e"
    property color colYellow: "#e0af68"
    property color colBlue: "#7aa2f7"

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors.top: true
            anchors.left: true
            anchors.right: true
            implicitHeight: 40
            color: "#1a1b26"

            RowLayout {
                anchors.fill: parent
                Repeater {
                    // Dynamically bind to existing workspaces and sort them numerically
                    model: {
                        var ws = Array.from(Hyprland.workspaces.values);
                        ws.sort((a, b) => a.id - b.id);
                        return ws;
                    }

                    Rectangle {
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: parent.height
                        color: "transparent"

                        // modelData represents the current workspace object from our sorted array
                        property var workspace: modelData
                        property bool isActive: Hyprland.focusedWorkspace?.id === workspace.id

                        Text {
                            text: parent.workspace.id
                            // If it's active, make it Cyan. If it just has windows, make it Muted.
                            color: parent.isActive ? root.colCyan : root.colMuted
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true
                            anchors.centerIn: parent
                        }

                        Rectangle {
                            width: 20
                            height: 3
                            // An underline indicator for the actively focused workspace
                            color: parent.isActive ? root.colPurple : root.colBg
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Hyprland.dispatch("workspace " + workspace.id)
                        }
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                text: root.time
                color: "#ccccff"
            }
        }
    }
    Process {
        id: dateProc

        command: ["date", "+%Y-%m-%d %H:%M:%S"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.time = this.text
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: dateProc.running = true
    }
}
