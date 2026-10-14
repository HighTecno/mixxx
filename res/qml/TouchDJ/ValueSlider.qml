import QtQuick
import "../Theme"

// Big horizontal slider with a readout, for settings. Relative drag, double tap resets.
Item {
    id: root

    property string label: ""
    property real from: 0
    property real to: 1
    property real value: 0
    property real defaultValue: from
    property int decimals: 1
    property string suffix: ""
    // multiply value by this for display (e.g. 1000 to show seconds as ms)
    property real displayScale: 1
    property color accent: Theme.blue
    readonly property real fraction: Math.max(0, Math.min(1, (value - from) / (to - from)))

    signal moved(real newValue)

    implicitHeight: 110

    Rectangle {
        anchors.fill: parent
        color: Theme.darkGray4
        radius: 14
    }
    Text {
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 8
        color: Theme.lightGray2
        font.bold: true
        font.pixelSize: 22
        text: root.label
    }
    Text {
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 6
        color: "white"
        font.bold: true
        font.pixelSize: 28
        text: (root.value * root.displayScale).toFixed(root.decimals) + root.suffix
    }
    Rectangle {
        id: groove

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 26
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.right: parent.right
        anchors.rightMargin: 24
        color: "black"
        height: 10
        radius: 5

        Rectangle {
            color: root.accent
            height: parent.height
            radius: 5
            width: parent.width * root.fraction
        }
        Rectangle {
            border.color: root.accent
            border.width: 3
            color: Theme.darkGray2
            height: 56
            radius: 12
            width: 50
            x: (groove.width - width) * root.fraction
            y: (groove.height - height) / 2
        }
    }

    DragHandler {
        id: dh

        property real startFraction

        target: null

        onActiveChanged: if (active) startFraction = root.fraction
        onCentroidChanged: {
            if (!active)
                return;
            const d = (centroid.scenePosition.x - centroid.scenePressPosition.x) / Math.max(1, groove.width - 50);
            const f = Math.max(0, Math.min(1, startFraction + d));
            root.moved(root.from + f * (root.to - root.from));
        }
    }
    ResetOnDoubleTap {
        onTriggered: root.moved(root.defaultValue)
    }
}
