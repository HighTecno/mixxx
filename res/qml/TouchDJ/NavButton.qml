import QtQuick
import "../Theme"

// Plain button for view navigation (not bound to a Mixxx control).
Rectangle {
    id: root

    property string label: ""
    property color accent: Theme.white
    property real fontSize: 28

    signal activated
    signal longPressed

    border.color: tap.pressed ? accent : Theme.darkGray3
    border.width: 3
    color: tap.pressed ? Theme.darkGray3 : Theme.darkGray2
    implicitHeight: 90
    implicitWidth: 240
    radius: 16

    Text {
        anchors.centerIn: parent
        color: "white"
        font.bold: true
        font.pixelSize: root.fontSize
        text: root.label
    }
    TapHandler {
        id: tap

        onLongPressed: root.longPressed()
        onTapped: root.activated()
    }
}
