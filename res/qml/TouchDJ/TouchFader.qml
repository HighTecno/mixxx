import Mixxx 1.0 as Mixxx
import QtQuick
import "../Theme"

// Relative-drag fader: the whole area is the touch target, dragging moves the
// handle by the finger's travel (no jumping). Double tap resets to default.
Item {
    id: root

    property string group
    property string key
    property bool horizontal: false
    property color accent: Theme.blue
    property real handleSize: 130
    property string label: ""
    readonly property real travel: Math.max(1, (horizontal ? width : height) - handleSize)
    property real dragParam: 0
    readonly property real p: dh.active ? dragParam : ctl.parameter

    Mixxx.ControlProxy {
        id: ctl

        group: root.group
        key: root.key
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.darkGray4
        radius: 14
    }
    // groove
    Rectangle {
        anchors.centerIn: parent
        color: "black"
        height: root.horizontal ? 10 : root.height - 40
        radius: 5
        width: root.horizontal ? root.width - 40 : 10
    }
    Rectangle {
        id: handle

        border.color: root.accent
        border.width: 3
        color: dh.active ? Theme.darkGray3 : Theme.darkGray2
        height: root.horizontal ? root.height - 16 : root.handleSize
        radius: 12
        width: root.horizontal ? root.handleSize : root.width - 16
        x: root.horizontal ? root.p * root.travel : 8
        y: root.horizontal ? 8 : (1 - root.p) * root.travel

        Rectangle {
            anchors.centerIn: parent
            color: root.accent
            height: root.horizontal ? parent.height * 0.6 : 6
            width: root.horizontal ? 6 : parent.width * 0.6
        }
    }
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 4
        color: Theme.midGray
        font.pixelSize: 18
        text: root.label
        visible: !root.horizontal
    }

    DragHandler {
        id: dh

        property real startP

        target: null

        onActiveChanged: if (active) startP = ctl.parameter
        onCentroidChanged: {
            if (!active)
                return;
            const d = root.horizontal
                ? centroid.scenePosition.x - centroid.scenePressPosition.x
                : -(centroid.scenePosition.y - centroid.scenePressPosition.y);
            const np = Math.max(0, Math.min(1, startP + d / root.travel));
            root.dragParam = np;
            ctl.parameter = np;
        }
    }
    TapHandler {
        onTapped: (eventPoint, button) => {
            if (tapCount === 2)
                ctl.reset();
        }
    }
}
