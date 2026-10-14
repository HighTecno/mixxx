import Mixxx 1.0 as Mixxx
import QtQuick
import "../Theme"
import "ValueFormat.js" as VF

// Knob driven by relative vertical drag. Double tap resets.
Item {
    id: root

    property string group
    property string key
    property string label: ""
    property string readoutText: ""
    property string format: VF.kindFor(group, key)
    readonly property string readout: readoutText !== "" ? readoutText : VF.format(format, ctl.value, ctl.parameter)
    property color accent: Theme.blue
    // pixels of finger travel for the full range
    property real sensitivity: 320

    Mixxx.ControlProxy {
        id: ctl

        group: root.group
        key: root.key
    }

    Rectangle {
        id: body

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        border.color: dh.active ? root.accent : Theme.darkGray3
        border.width: 3
        color: Theme.darkGray2
        height: Math.min(parent.width, parent.height - 26)
        radius: width / 2
        width: height

        Rectangle {
            color: root.accent
            height: parent.height * 0.4
            radius: 3
            width: 6
            x: parent.width / 2 - 3
            y: 6
            transformOrigin: Item.Bottom
            // the pointer rotates around the knob centre
            transform: Rotation {
                angle: -135 + 270 * ctl.parameter
                origin.x: 3
                origin.y: body.height / 2 - 6
            }
        }
    }
    Text {
        anchors.horizontalCenter: body.horizontalCenter
        color: "white"
        font.bold: true
        font.pixelSize: 17
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignHCenter
        minimumPixelSize: 10
        text: root.readout
        width: body.width * 0.8
        y: body.y + body.height * 0.56
    }
    Text {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: Theme.lightGray2
        font.bold: true
        font.pixelSize: 20
        text: root.label
    }

    DragHandler {
        id: dh

        property real startP

        target: null

        onActiveChanged: if (active) startP = ctl.parameter
        onCentroidChanged: {
            if (!active)
                return;
            const d = -(centroid.scenePosition.y - centroid.scenePressPosition.y);
            ctl.parameter = Math.max(0, Math.min(1, startP + d / root.sensitivity));
        }
    }
    ResetOnDoubleTap {
        onTriggered: ctl.reset()
    }
}
