import Mixxx 1.0 as Mixxx
import QtQuick
import QtQuick.Layouts
import "../Theme"

// One effect slot: ON, effect name (tap to pick), META knob, parameter knobs.
Item {
    id: root

    required property int unitNumber
    required property int effectNumber
    readonly property var slot: Mixxx.EffectsManager.getEffectSlot(unitNumber, effectNumber)
    readonly property string group: slot.group

    EffectPicker {
        id: picker

        slot: root.slot
    }

    RowLayout {
        anchors.fill: parent
        spacing: 8

        TouchButton {
            accent: Theme.effectColor
            group: root.group
            key: "enabled"
            label: "ON"
            Layout.fillHeight: true
            Layout.preferredWidth: 84
        }
        NavButton {
            fontSize: 22
            label: root.slot.loaded ? root.slot.effectName : "— none —"
            Layout.fillHeight: true
            Layout.preferredWidth: 210

            onActivated: picker.open()
        }
        TouchKnob {
            accent: Theme.effectColor
            group: root.group
            key: "meta"
            label: "META"
            Layout.fillHeight: true
            Layout.preferredWidth: 92
        }
        Repeater {
            model: root.slot.parametersModel

            Item {
                id: param

                required property string controlKey
                required property int index
                required property bool loaded
                required property string name
                required property string shortName
                required property int type
                readonly property int slotNumber: {
                    const m = controlKey.match(/(\d+)$/);
                    return m ? Number(m[1]) : 0;
                }
                readonly property bool shown: loaded && slotNumber > 0 && slotNumber <= 6

                Layout.fillHeight: true
                Layout.preferredWidth: shown ? 86 : 0
                visible: shown

                Loader {
                    active: param.shown && param.type === Mixxx.EffectSlotParametersModel.Knob
                    anchors.fill: parent

                    sourceComponent: TouchKnob {
                        accent: Theme.effectColor
                        group: root.group
                        key: param.controlKey
                        label: (param.shortName || param.name).substring(0, 7).toUpperCase()
                    }
                }
                Loader {
                    active: param.shown && param.type === Mixxx.EffectSlotParametersModel.Button
                    anchors.fill: parent
                    anchors.margins: 4

                    sourceComponent: TouchButton {
                        accent: Theme.effectColor
                        fontSize: 16
                        group: root.group
                        key: param.controlKey
                        label: (param.shortName || param.name).substring(0, 7).toUpperCase()
                    }
                }
            }
        }
        Item {
            Layout.fillWidth: true
        }
    }
}
