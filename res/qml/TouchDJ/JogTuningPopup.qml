import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Tuning"
import "../Theme"

// Non-modal so you can keep scratching while you adjust.
Popup {
    id: root

    closePolicy: Popup.NoAutoClose
    modal: false
    padding: 14
    parent: Overlay.overlay
    width: 1180
    x: Math.round((parent.width - width) / 2)
    y: 84

    background: Rectangle {
        border.color: Theme.blue
        border.width: 3
        color: Theme.darkGray
        opacity: 0.96
        radius: 16
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            spacing: 14
            Layout.fillWidth: true

            ValueSlider {
                decimals: 0
                defaultValue: JogTuning.defaultSmoothing
                displayScale: 1000
                from: 0.002
                label: "SCRATCH SMOOTHING"
                suffix: " ms"
                to: 0.08
                value: JogTuning.smoothing
                Layout.fillWidth: true

                onMoved: v => JogTuning.smoothing = v
            }
            ValueSlider {
                decimals: 1
                defaultValue: JogTuning.defaultBendGain
                from: 0.3
                label: "NUDGE STRENGTH"
                to: 8
                value: JogTuning.bendGain
                Layout.fillWidth: true

                onMoved: v => JogTuning.bendGain = v
            }
        }
        RowLayout {
            spacing: 14
            Layout.fillWidth: true

            Text {
                color: Theme.midGray
                font.pixelSize: 20
                text: "Smoothing: lower = tighter, higher = smoother.  Nudge = outer ring.  Double tap a slider to reset; changes apply instantly and are saved."
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            NavButton {
                label: "RESET"
                Layout.preferredHeight: 64
                Layout.preferredWidth: 180

                onActivated: JogTuning.resetDefaults()
            }
            NavButton {
                accent: "#3ddc84"
                label: "DONE"
                Layout.preferredHeight: 64
                Layout.preferredWidth: 180

                onActivated: root.close()
            }
        }
    }
}
