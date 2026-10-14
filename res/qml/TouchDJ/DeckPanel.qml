import Mixxx 1.0 as Mixxx
import QtQuick
import QtQuick.Layouts
import "../Theme"

// One deck: tempo fader on the outer edge, big jogwheel, transport, 8 hotcues.
Item {
    id: root

    required property string group
    // true = tempo fader on the right (deck 2)
    property bool mirrored: false
    property color accent: Theme.blue
    readonly property var player: Mixxx.PlayerManager.getPlayer(group)
    property int page: 0
    readonly property real remaining: duration.value * (1 - playposition.value)

    function fmt(sec) {
        if (!isFinite(sec) || sec < 0)
            return "--:--";
        const m = Math.floor(sec / 60);
        const r = Math.floor(sec % 60);
        return m + ":" + (r < 10 ? "0" : "") + r;
    }

    Mixxx.ControlProxy {
        id: bpm

        group: root.group
        key: "bpm"
    }
    Mixxx.ControlProxy {
        id: duration

        group: root.group
        key: "duration"
    }
    Mixxx.ControlProxy {
        id: playposition

        group: root.group
        key: "playposition"
    }
    Mixxx.ControlProxy {
        id: beatjumpSize

        group: root.group
        key: "beatjump_size"
    }

    RowLayout {
        anchors.fill: parent
        layoutDirection: root.mirrored ? Qt.RightToLeft : Qt.LeftToRight
        spacing: 14

        TouchFader {
            accent: root.accent
            group: root.group
            key: "rate"
            label: "TEMPO"
            Layout.fillHeight: true
            Layout.preferredWidth: 110
        }

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 12

            // track title, BPM and remaining time
            RowLayout {
                spacing: 16
                Layout.fillHeight: false
                Layout.fillWidth: true

                Text {
                    color: Theme.lightGray2
                    elide: Text.ElideRight
                    font.pixelSize: 26
                    text: root.player && root.player.isLoaded ? root.player.currentTrack.title : "No track loaded"
                    Layout.fillWidth: true
                }
                Text {
                    color: root.accent
                    font.bold: true
                    font.pixelSize: 30
                    text: bpm.value > 0 ? bpm.value.toFixed(1) + " BPM" : "-- BPM"
                }
                Text {
                    color: "white"
                    font.bold: true
                    font.pixelSize: 30
                    text: "-" + root.fmt(root.remaining)
                }
            }

            TouchJogWheel {
                accent: root.accent
                group: root.group
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.minimumHeight: 300
            }

            RowLayout {
                spacing: 12
                Layout.fillHeight: false
                Layout.fillWidth: true

                TouchButton {
                    accent: root.accent
                    group: root.group
                    key: "cue_default"
                    label: "CUE"
                    momentary: true
                    Layout.fillWidth: true
                    Layout.preferredHeight: 110
                }
                TouchButton {
                    accent: "#3ddc84"
                    group: root.group
                    key: "play"
                    label: "PLAY"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 110
                }
                TouchButton {
                    accent: "#ffb300"
                    group: root.group
                    key: "sync_enabled"
                    label: "SYNC"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 110
                }
            }

            // page tabs
            RowLayout {
                spacing: 8
                Layout.fillHeight: false
                Layout.fillWidth: true

                Repeater {
                    model: ["HOTCUES", "LOOP / JUMP", "KEY / FX"]

                    NavButton {
                        required property int index
                        required property string modelData

                        accent: root.accent
                        color: root.page === index ? Qt.darker(root.accent, 2.2) : Theme.darkGray4
                        fontSize: 20
                        label: modelData
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48

                        onActivated: root.page = index
                    }
                }
            }

            StackLayout {
                currentIndex: root.page
                Layout.fillHeight: false
                Layout.fillWidth: true
                Layout.maximumHeight: 168
                Layout.minimumHeight: 168
                Layout.preferredHeight: 168

                // 0: hotcues
                GridLayout {
                    columnSpacing: 10
                    columns: 4
                    rowSpacing: 10

                    Repeater {
                        model: 8

                        HotcuePad {
                            required property int index

                            group: root.group
                            number: index + 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                        }
                    }
                }

                // 1: loops and beatjump
                GridLayout {
                    columnSpacing: 10
                    columns: 5
                    rowSpacing: 10

                    TouchButton { group: root.group; key: "loop_in"; label: "IN"; momentary: true; Layout.fillHeight: true; Layout.fillWidth: true }
                    TouchButton { group: root.group; key: "loop_out"; label: "OUT"; momentary: true; Layout.fillHeight: true; Layout.fillWidth: true }
                    TouchButton { accent: "#3ddc84"; group: root.group; key: "loop_enabled"; label: "LOOP"; Layout.fillHeight: true; Layout.fillWidth: true }
                    TouchButton { group: root.group; key: "loop_halve"; label: "½"; momentary: true; Layout.fillHeight: true; Layout.fillWidth: true }
                    TouchButton { group: root.group; key: "loop_double"; label: "2×"; momentary: true; Layout.fillHeight: true; Layout.fillWidth: true }

                    TouchButton { group: root.group; key: "beatjump_backward"; label: "◀ JUMP"; momentary: true; Layout.fillHeight: true; Layout.fillWidth: true }
                    TouchButton { group: root.group; key: "beatjump_forward"; label: "JUMP ▶"; momentary: true; Layout.fillHeight: true; Layout.fillWidth: true }
                    NavButton {
                        label: "SIZE " + beatjumpSize.value
                        fontSize: 22
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        onActivated: beatjumpSize.value = beatjumpSize.value >= 64 ? 0.5 : beatjumpSize.value * 2
                    }
                    TouchButton { group: root.group; key: "beatloop_4_toggle"; label: "LOOP 4"; Layout.fillHeight: true; Layout.fillWidth: true }
                    TouchButton { group: root.group; key: "beatloop_8_toggle"; label: "LOOP 8"; Layout.fillHeight: true; Layout.fillWidth: true }
                }

                // 2: key, reverse, headphone cue, eject, effect assignment
                GridLayout {
                    columnSpacing: 10
                    columns: 5
                    rowSpacing: 10

                    TouchButton { accent: "#ffb300"; group: root.group; key: "keylock"; label: "KEYLOCK"; fontSize: 20; Layout.fillHeight: true; Layout.fillWidth: true }
                    TouchButton { group: root.group; key: "pitch_down"; label: "KEY −"; momentary: true; Layout.fillHeight: true; Layout.fillWidth: true }
                    TouchButton { group: root.group; key: "pitch_up"; label: "KEY +"; momentary: true; Layout.fillHeight: true; Layout.fillWidth: true }
                    TouchButton { group: root.group; key: "reverse"; label: "REV"; Layout.fillHeight: true; Layout.fillWidth: true }
                    TouchButton { group: root.group; key: "pfl"; label: "HEAD"; Layout.fillHeight: true; Layout.fillWidth: true }

                    Repeater {
                        model: 4

                        TouchButton {
                            required property int index

                            accent: "#ffd54f"
                            group: "[EffectRack1_EffectUnit" + (index + 1) + "]"
                            key: "group_" + root.group + "_enable"
                            label: "FX" + (index + 1)
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                        }
                    }
                    TouchButton { group: root.group; key: "eject"; label: "EJECT"; momentary: true; fontSize: 20; Layout.fillHeight: true; Layout.fillWidth: true }
                }
            }
        }
    }
}
