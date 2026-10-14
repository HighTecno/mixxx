import QtQuick
import QtQuick.Layouts
import "../Theme"

Rectangle {
    id: root

    required property int unitNumber
    readonly property string group: "[EffectRack1_EffectUnit" + unitNumber + "]"

    border.color: Theme.darkGray3
    border.width: 2
    color: Theme.darkGray4
    radius: 14

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        RowLayout {
            spacing: 10
            Layout.fillHeight: false
            Layout.fillWidth: true
            Layout.preferredHeight: 100

            Text {
                color: Theme.effectColor
                font.bold: true
                font.pixelSize: 30
                text: "FX " + root.unitNumber
                Layout.preferredWidth: 100
            }
            TouchKnob {
                accent: Theme.effectColor
                group: root.group
                key: "mix"
                label: "MIX"
                Layout.fillHeight: true
                Layout.preferredWidth: 92
            }
            TouchKnob {
                accent: Theme.effectColor
                group: root.group
                key: "super1"
                label: "SUPER"
                Layout.fillHeight: true
                Layout.preferredWidth: 92
            }
            TouchButton {
                accent: Theme.effectColor
                fontSize: 20
                group: root.group
                key: "group_[Headphone]_enable"
                label: "HEAD"
                Layout.fillHeight: true
                Layout.preferredWidth: 110
            }
            Item {
                Layout.fillWidth: true
            }
        }
        Repeater {
            model: 3

            EffectSlotRow {
                required property int index

                effectNumber: index + 1
                unitNumber: root.unitNumber
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }
    }
}
