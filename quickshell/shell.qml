//@ pragma IconTheme Papirus-Dark
import Quickshell
import Quickshell.Io
import QtQuick
import "modules"

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
        }
    }

    Variants {
        model: Quickshell.screens

        NotificationPanel {
            required property var modelData
            screen: modelData
        }
    }

    Launcher {
        id: launcher
    }

    Osd {
    }

    Clipboard {
    }

    Expose {
    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            launcher.toggle();
        }
    }
}
