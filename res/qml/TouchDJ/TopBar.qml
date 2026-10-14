import QtQuick
import QtQuick.Layouts
import "../Theme"

// Always-visible navigation: one tap to any view.
Rectangle {
    id: root

    property string view: "decks"
    property bool upperDecks: false

    signal viewRequested(string view)
    signal upperDecksToggled
    signal settingsRequested
    signal legacySettingsRequested

    color: Theme.darkGray
    implicitHeight: 76

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Repeater {
            model: [
                {id: "decks", label: "DECKS"},
                {id: "library", label: "LIBRARY"},
                {id: "effects", label: "EFFECTS"},
                {id: "samplers", label: "SAMPLERS"},
                {id: "audio", label: "AUDIO"}
            ]

            NavButton {
                required property var modelData

                accent: Theme.blue
                color: root.view === modelData.id ? Qt.darker(Theme.blue, 2.4) : Theme.darkGray2
                label: modelData.label
                Layout.fillHeight: true
                Layout.preferredWidth: 210

                onActivated: root.viewRequested(modelData.id)
            }
        }
        Item {
            Layout.fillWidth: true
        }
        NavButton {
            accent: "#ffb300"
            label: root.upperDecks ? "DECKS 1 / 2" : "DECKS 3 / 4"
            Layout.fillHeight: true
            Layout.preferredWidth: 210

            onActivated: root.upperDecksToggled()
        }
        NavButton {
            label: "SETTINGS"
            Layout.fillHeight: true
            Layout.preferredWidth: 210

            onActivated: root.settingsRequested()
            onLongPressed: root.legacySettingsRequested()
        }
    }
}
