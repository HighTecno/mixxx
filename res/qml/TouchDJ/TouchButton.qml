import Mixxx 1.0 as Mixxx
import QtQuick
import "../Theme"

// Big touch button bound to a Mixxx control. Uses TapHandler (not MouseArea)
// so that several buttons can be held by different fingers at once.
Rectangle {
    id: root

    property string group
    property string key
    property string label: ""
    property real fontSize: 26
    // momentary: control follows the finger (cue, hotcue). Otherwise toggles on press.
    property bool momentary: false
    property color accent: Theme.blue
    readonly property bool lit: ctl.value > 0 || tap.pressed

    border.color: lit ? accent : Theme.darkGray3
    border.width: 3
    color: lit ? Qt.darker(accent, 2.2) : Theme.darkGray2
    implicitHeight: 110
    implicitWidth: 150
    radius: 16

    Mixxx.ControlProxy {
        id: ctl

        group: root.group
        key: root.key
    }

    Text {
        anchors.centerIn: parent
        color: root.lit ? "white" : Theme.lightGray2
        font.bold: true
        font.pixelSize: root.fontSize
        text: root.label
    }

    TapHandler {
        id: tap

        gesturePolicy: TapHandler.ReleaseWithinBounds

        onPressedChanged: {
            if (root.momentary)
                ctl.value = pressed ? 1 : 0;
            else if (pressed)
                ctl.value = ctl.value > 0 ? 0 : 1;
        }
    }
}
