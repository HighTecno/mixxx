import "." as Touch
import ".." as Skin
import Mixxx 1.0 as Mixxx
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Theme"

// Root of the touch DJ UI. A permanent top bar switches between full-screen views,
// so the deck view never has to share space with the library.
Item {
    id: root

    // main.qml expects these on whatever it loads
    property var applicationWindow
    property var menuBar: null

    readonly property int numDecks: 4
    readonly property int numSamplers: 16
    readonly property int numPreviewDecks: 1
    readonly property int waveformOverviewTypeRgb: 2

    property string view: "decks"
    property bool upperDecks: false
    // sampler the library should load into (0 = none)
    property int samplerTarget: 0

    function show(name) {
        if (name !== "library")
            samplerTarget = 0;
        view = name;
    }

    // Same engine setup the stock window does; without it decks 3/4 and samplers don't exist.
    Mixxx.ControlProxy {
        group: "[App]"
        key: "num_decks"

        onInitializedChanged: value = root.numDecks
    }
    Mixxx.ControlProxy {
        group: "[App]"
        key: "num_samplers"

        onInitializedChanged: value = root.numSamplers
    }
    Mixxx.ControlProxy {
        group: "[App]"
        key: "num_preview_decks"

        onInitializedChanged: value = root.numPreviewDecks
    }
    Mixxx.ControlProxy {
        group: "[Waveform]"
        key: "WaveformOverviewType"

        onInitializedChanged: value = root.waveformOverviewTypeRgb
    }

    // keyboard shortcuts / menu commands of the stock UI keep working
    Skin.ApplicationMenuCommands {
        id: menuCommands

        applicationWindow: root.applicationWindow

        onShowDeveloperToolsRequested: root.openDevTools()
    }
    Skin.ApplicationMenuActions {
        id: menuActions

        applicationWindow: root.applicationWindow
        commands: menuCommands
        numberOfDecks: 4

        onFocusLibrarySearchRequested: {
            root.show("library");
            library.focusSearch();
        }
    }
    Skin.LibraryScanSummaryDialog {
    }

    function openDevTools() {
        devTools.show();
        devTools.raise();
        devTools.requestActivate();
    }

    Skin.DeveloperToolsWindow {
        id: devTools

        height: 480
        width: 640
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TopBar {
            upperDecks: root.upperDecks
            view: root.view
            Layout.fillWidth: true
            Layout.preferredHeight: 76

            onLegacySettingsRequested: Mixxx.PreferencesDialog.show()
            onJogTuningRequested: jogPopup.opened ? jogPopup.close() : jogPopup.open()
            onSettingsRequested: settingsPopup.open()
            onUpperDecksToggled: {
                root.upperDecks = !root.upperDecks;
                root.show("decks");
            }
            onViewRequested: name => root.show(name)
        }

        // all views stay instantiated (the library keeps its state and the
        // waveforms keep running); only one is visible.
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            DeckView {
                anchors.fill: parent
                leftGroup: root.upperDecks ? "[Channel3]" : "[Channel1]"
                rightGroup: root.upperDecks ? "[Channel4]" : "[Channel2]"
                visible: root.view === "decks"
            }
            LibraryView {
                id: library

                anchors.fill: parent
                samplerTarget: root.samplerTarget
                visible: root.view === "library"

                onCloseRequested: root.show(root.samplerTarget > 0 ? "samplers" : "decks")
            }
            EffectsView {
                anchors.fill: parent
                visible: root.view === "effects"
            }
            SamplersView {
                anchors.fill: parent
                visible: root.view === "samplers"

                onPickTrackFor: sampler => {
                    root.samplerTarget = sampler;
                    root.view = "library";
                }
            }
            AudioView {
                anchors.fill: parent
                visible: root.view === "audio"

                onDeveloperToolsRequested: root.openDevTools()
            }
        }
    }

    JogTuningPopup {
        id: jogPopup
    }

    Skin.Settings {
        id: settingsPopup

        height: Math.min(840, root.height)
        modal: true
        width: Math.min(1400, root.width)
        x: Math.round((root.width - width) / 2)
        y: Math.round((root.height - height) / 2)
    }
}
