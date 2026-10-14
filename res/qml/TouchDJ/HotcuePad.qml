import Mixxx 1.0 as Mixxx
import QtQuick
import "../Theme"

Rectangle {
    id: root

    required property string group
    required property int number
    readonly property bool isSet: status.value > 0
    readonly property color padColor: color_.value < 0 ? Theme.blue : "#" + color_.value.toString(16).padStart(6, "0")

    border.color: isSet ? padColor : Theme.darkGray3
    border.width: 3
    color: tap.pressed ? padColor : (isSet ? Qt.darker(padColor, 2.4) : Theme.darkGray4)
    implicitHeight: 80
    implicitWidth: 140
    radius: 12

    Mixxx.ControlProxy {
        id: activate

        group: root.group
        key: "hotcue_" + root.number + "_activate"
    }
    Mixxx.ControlProxy {
        id: status

        group: root.group
        key: "hotcue_" + root.number + "_status"
    }
    Mixxx.ControlProxy {
        id: color_

        group: root.group
        key: "hotcue_" + root.number + "_color"
    }

    Text {
        anchors.centerIn: parent
        color: root.isSet ? "white" : Theme.midGray
        font.bold: true
        font.pixelSize: 28
        text: root.number
    }

    TapHandler {
        id: tap

        gesturePolicy: TapHandler.ReleaseWithinBounds

        onPressedChanged: activate.value = pressed ? 1 : 0
    }
}
