import QtQuick
import QtQuick.Layouts
import "../Theme"

// Centre mixer: per-channel gain/EQ/filter knobs + volume faders, crossfader below.
Item {
    id: root

    property string leftChannel: "[Channel1]"
    property string rightChannel: "[Channel2]"

    component Strip: ColumnLayout {
        id: strip

        required property string channel   // e.g. "[Channel1]"
        property color accent: Theme.blue
        spacing: 4

        TouchKnob {
            accent: strip.accent
            group: strip.channel
            key: "pregain"
            label: "GAIN"
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        TouchKnob {
            accent: strip.accent
            group: "[EqualizerRack1_" + strip.channel + "_Effect1]"
            key: "parameter3"
            label: "HIGH"
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        TouchKnob {
            accent: strip.accent
            group: "[EqualizerRack1_" + strip.channel + "_Effect1]"
            key: "parameter2"
            label: "MID"
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        TouchKnob {
            accent: strip.accent
            group: "[EqualizerRack1_" + strip.channel + "_Effect1]"
            key: "parameter1"
            label: "LOW"
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        TouchKnob {
            accent: strip.accent
            group: "[QuickEffectRack1_" + strip.channel + "]"
            key: "super1"
            label: "FILTER"
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 14

        RowLayout {
            spacing: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

            Strip {
                accent: "#4aa3ff"
                channel: root.leftChannel
                Layout.fillHeight: true
                Layout.preferredWidth: 120
            }
            TouchFader {
                accent: "#4aa3ff"
                group: root.leftChannel
                key: "volume"
                label: "VOL"
                Layout.fillHeight: true
                Layout.preferredWidth: 100
            }
            TouchFader {
                accent: "#ff5c8a"
                group: root.rightChannel
                key: "volume"
                label: "VOL"
                Layout.fillHeight: true
                Layout.preferredWidth: 100
            }
            Strip {
                accent: "#ff5c8a"
                channel: root.rightChannel
                Layout.fillHeight: true
                Layout.preferredWidth: 120
            }
        }

        TouchFader {
            accent: Theme.white
            group: "[Master]"
            handleSize: 150
            horizontal: true
            key: "crossfader"
            Layout.fillWidth: true
            Layout.preferredHeight: 120
        }
    }
}
