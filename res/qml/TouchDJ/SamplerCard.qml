import Mixxx 1.0 as Mixxx
import QtQuick
import QtQuick.Layouts
import "../Theme"

Rectangle {
    id: root

    required property int number
    readonly property string group: "[Sampler" + number + "]"
    readonly property var player: Mixxx.PlayerManager.getPlayer(group)

    signal loadRequested

    border.color: Theme.darkGray3
    border.width: 2
    color: Theme.darkGray4
    radius: 14

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        Text {
            color: Theme.lightGray2
            elide: Text.ElideRight
            font.pixelSize: 22
            text: root.number + "  " + (root.player && root.player.isLoaded ? root.player.currentTrack.title : "empty")
            Layout.fillWidth: true
        }
        // big trigger pad: jump to cue and play
        TouchButton {
            accent: "#3ddc84"
            fontSize: 34
            group: root.group
            key: "play"
            label: "▶"
            momentary: false
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        RowLayout {
            spacing: 8
            Layout.fillHeight: false
            Layout.fillWidth: true
            Layout.preferredHeight: 80

            TouchButton { fontSize: 18; group: root.group; key: "cue_gotoandplay"; label: "RESTART"; momentary: true; Layout.fillHeight: true; Layout.fillWidth: true }
            TouchButton { fontSize: 18; group: root.group; key: "repeat"; label: "LOOP"; Layout.fillHeight: true; Layout.fillWidth: true }
            TouchButton { accent: "#ffb300"; fontSize: 18; group: root.group; key: "sync_enabled"; label: "SYNC"; Layout.fillHeight: true; Layout.fillWidth: true }
        }
        RowLayout {
            spacing: 8
            Layout.fillHeight: false
            Layout.fillWidth: true
            Layout.preferredHeight: 80

            NavButton {
                accent: Theme.blue
                fontSize: 18
                label: "LOAD"
                Layout.fillHeight: true
                Layout.fillWidth: true

                onActivated: root.loadRequested()
            }
            TouchButton { fontSize: 18; group: root.group; key: "eject"; label: "EJECT"; momentary: true; Layout.fillHeight: true; Layout.fillWidth: true }
            TouchButton { fontSize: 18; group: root.group; key: "pfl"; label: "HEAD"; Layout.fillHeight: true; Layout.fillWidth: true }
        }
        RowLayout {
            spacing: 8
            Layout.fillHeight: false
            Layout.fillWidth: true
            Layout.preferredHeight: 100

            TouchKnob { group: root.group; key: "pregain"; label: "GAIN"; Layout.fillHeight: true; Layout.fillWidth: true }
            TouchKnob { group: root.group; key: "rate"; label: "RATE"; Layout.fillHeight: true; Layout.fillWidth: true }
            TouchKnob { group: root.group; key: "volume"; label: "VOL"; Layout.fillHeight: true; Layout.fillWidth: true }
        }
    }
}
