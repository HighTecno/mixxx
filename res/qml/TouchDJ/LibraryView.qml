import Mixxx 1.0 as Mixxx
import QtQuick
import QtQuick.Layouts
import ".." as Skin
import "../Theme"

// Full-screen track browser. Reuses the stock Library; adds big load buttons.
Rectangle {
    id: root

    // >0: the next load goes into this sampler
    property int samplerTarget: 0

    signal closeRequested

    function focusSearch() {
        lib.focusSearch();
    }

    function loadInto(n) {
        const c = loaders.itemAt(n - 1);
        c.value = 1;
        c.value = 0;
        closeTimer.restart();
    }

    color: Theme.backgroundColor

    Repeater {
        id: loaders

        model: 4

        Item {
            id: loader

            required property int index
            property alias value: proxy.value

            Mixxx.ControlProxy {
                id: proxy

                group: "[Channel" + (loader.index + 1) + "]"
                key: "LoadSelectedTrack"
            }
        }
    }
    Mixxx.ControlProxy {
        id: samplerLoad

        group: "[Sampler" + Math.max(1, root.samplerTarget) + "]"
        key: "LoadSelectedTrack"
    }
    // go back to the decks shortly after loading so the DJ sees the result
    Timer {
        id: closeTimer

        interval: 450

        onTriggered: root.closeRequested()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        RowLayout {
            spacing: 12
            Layout.fillHeight: false
            Layout.fillWidth: true
            Layout.preferredHeight: 90

            NavButton {
                accent: "#3ddc84"
                label: "LOAD → SAMPLER " + root.samplerTarget
                visible: root.samplerTarget > 0
                Layout.preferredHeight: 90
                Layout.preferredWidth: 420

                onActivated: {
                    samplerLoad.value = 1;
                    samplerLoad.value = 0;
                    closeTimer.restart();
                }
            }
            Item {
                Layout.fillWidth: true
            }
            Repeater {
                model: 4

                NavButton {
                    required property int index

                    accent: index % 2 === 0 ? "#4aa3ff" : "#ff5c8a"
                    fontSize: 24
                    label: "LOAD → " + (index + 1)
                    Layout.preferredHeight: 90
                    Layout.preferredWidth: 190

                    onActivated: root.loadInto(index + 1)
                }
            }
        }

        // The stock library is built for a mouse (30 px rows, small text). Render it
        // scaled up so rows and text are finger-sized, without touching stock files.
        Item {
            id: libraryHolder

            readonly property real zoom: 1.8

            clip: true
            Layout.fillHeight: true
            Layout.fillWidth: true

            Skin.Library {
                id: lib

                height: libraryHolder.height / libraryHolder.zoom
                scale: libraryHolder.zoom
                transformOrigin: Item.TopLeft
                width: libraryHolder.width / libraryHolder.zoom
            }
        }
    }
}
