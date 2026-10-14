import Mixxx 1.0 as Mixxx
import QtQuick
import QtQuick.Layouts
import ".." as Skin
import "../Theme"

// Performance view: no library, just waveforms, two decks and the mixer.
Rectangle {
    id: root

    property string leftGroup: "[Channel1]"
    property string rightGroup: "[Channel2]"

    color: Theme.backgroundColor

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // zoomed waveforms, both decks stacked
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 280

            Skin.WaveformDisplay {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                group: root.leftGroup
                height: parent.height / 2
            }
            Skin.WaveformDisplay {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                group: root.rightGroup
                height: parent.height / 2
            }
        }

        RowLayout {
            spacing: 16
            Layout.fillHeight: true
            Layout.fillWidth: true

            DeckPanel {
                accent: "#4aa3ff"
                group: root.leftGroup
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
            MixerPanel {
                leftChannel: root.leftGroup
                rightChannel: root.rightGroup
                Layout.fillHeight: true
                Layout.preferredWidth: 480
            }
            DeckPanel {
                accent: "#ff5c8a"
                group: root.rightGroup
                mirrored: true
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }
    }
}
