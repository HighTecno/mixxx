import Mixxx 1.0 as Mixxx
import QtQuick
import QtQuick.Layouts
import ".." as Skin
import "../Theme"

// Master / headphones, microphones, aux inputs, recording, developer tools.
Rectangle {
    id: root

    signal developerToolsRequested

    color: Theme.backgroundColor

    component Section: Rectangle {
        property string title: ""
        default property alias content: inner.data

        border.color: Theme.darkGray3
        border.width: 2
        color: Theme.darkGray4
        radius: 14

        Text {
            anchors.left: parent.left
            anchors.margins: 12
            anchors.top: parent.top
            color: Theme.midGray
            font.bold: true
            font.pixelSize: 20
            text: parent.title
        }
        Item {
            id: inner

            anchors.fill: parent
            anchors.margins: 12
            anchors.topMargin: 44
        }
    }

    component InputStrip: Item {
        id: strip

        required property string group
        property string title: ""
        property bool isMic: false
        readonly property bool configured: configuredCtl.value > 0

        Mixxx.ControlProxy {
            id: configuredCtl

            group: strip.group
            key: "input_configured"
        }
        ColumnLayout {
            anchors.fill: parent
            spacing: 6
            opacity: strip.configured ? 1 : 0.35

            Text {
                color: Theme.lightGray2
                font.bold: true
                font.pixelSize: 20
                text: strip.title + (strip.configured ? "" : " (no input)")
                Layout.fillWidth: true
            }
            TouchKnob { group: strip.group; key: "pregain"; label: "GAIN"; Layout.fillHeight: true; Layout.fillWidth: true }
            TouchButton {
                fontSize: 20
                group: strip.group
                key: strip.isMic ? "talkover" : "master"
                label: strip.isMic ? "TALK" : "MASTER"
                Layout.fillWidth: true
                Layout.preferredHeight: 70
            }
            TouchButton { fontSize: 20; group: strip.group; key: "pfl"; label: "HEAD"; Layout.fillWidth: true; Layout.preferredHeight: 70 }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        RowLayout {
            spacing: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

            Section {
                title: "MASTER / HEADPHONES"
                Layout.fillHeight: true
                Layout.preferredWidth: 720

                RowLayout {
                    anchors.fill: parent
                    spacing: 8

                    TouchFader { accent: Theme.white; group: "[Master]"; key: "gain"; label: "MASTER"; Layout.fillHeight: true; Layout.preferredWidth: 110 }
                    TouchFader { accent: Theme.blue; group: "[Master]"; key: "headGain"; label: "HEAD"; Layout.fillHeight: true; Layout.preferredWidth: 110 }
                    ColumnLayout {
                        spacing: 6
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        TouchKnob { group: "[Master]"; key: "headMix"; label: "CUE MIX"; Layout.fillHeight: true; Layout.fillWidth: true }
                        TouchKnob { group: "[Master]"; key: "balance"; label: "BALANCE"; Layout.fillHeight: true; Layout.fillWidth: true }
                        TouchKnob { group: "[Master]"; key: "duckStrength"; label: "DUCK"; Layout.fillHeight: true; Layout.fillWidth: true }
                    }
                }
            }
            Section {
                title: "MICROPHONES"
                Layout.fillHeight: true
                Layout.fillWidth: true

                RowLayout {
                    anchors.fill: parent
                    spacing: 10

                    InputStrip { group: "[Microphone]"; isMic: true; title: "MIC 1"; Layout.fillHeight: true; Layout.fillWidth: true }
                    InputStrip { group: "[Microphone2]"; isMic: true; title: "MIC 2"; Layout.fillHeight: true; Layout.fillWidth: true }
                    InputStrip { group: "[Microphone3]"; isMic: true; title: "MIC 3"; Layout.fillHeight: true; Layout.fillWidth: true }
                    InputStrip { group: "[Microphone4]"; isMic: true; title: "MIC 4"; Layout.fillHeight: true; Layout.fillWidth: true }
                }
            }
        }
        RowLayout {
            spacing: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

            Section {
                title: "AUX INPUTS"
                Layout.fillHeight: true
                Layout.fillWidth: true

                RowLayout {
                    anchors.fill: parent
                    spacing: 10

                    InputStrip { group: "[Auxiliary1]"; title: "AUX 1"; Layout.fillHeight: true; Layout.fillWidth: true }
                    InputStrip { group: "[Auxiliary2]"; title: "AUX 2"; Layout.fillHeight: true; Layout.fillWidth: true }
                    InputStrip { group: "[Auxiliary3]"; title: "AUX 3"; Layout.fillHeight: true; Layout.fillWidth: true }
                    InputStrip { group: "[Auxiliary4]"; title: "AUX 4"; Layout.fillHeight: true; Layout.fillWidth: true }
                }
            }
            Section {
                title: "SESSION"
                Layout.fillHeight: true
                Layout.preferredWidth: 720

                GridLayout {
                    anchors.fill: parent
                    columnSpacing: 10
                    columns: 2
                    rowSpacing: 10

                    TouchButton { accent: "#ff4040"; group: "[Recording]"; key: "toggle_recording"; label: "● RECORD"; Layout.fillHeight: true; Layout.fillWidth: true }
                    TouchButton { accent: "#3ddc84"; group: "[AutoDJ]"; key: "enabled"; label: "AUTO DJ"; Layout.fillHeight: true; Layout.fillWidth: true }
                    NavButton { label: "DEVELOPER TOOLS"; fontSize: 22; Layout.fillHeight: true; Layout.fillWidth: true; onActivated: root.developerToolsRequested() }
                    NavButton { accent: "#ff4040"; label: "QUIT (HOLD)"; fontSize: 22; Layout.fillHeight: true; Layout.fillWidth: true; onLongPressed: Qt.quit() }
                }
            }
        }
    }
}
