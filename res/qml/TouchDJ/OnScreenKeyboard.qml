import QtQuick
import QtQuick.Layouts
import "../Theme"

// Minimal touch keyboard (QWERTZ, Swiss layout) that types into a TextField.
// It never takes focus, so the field keeps its cursor while you tap keys.
Rectangle {
    id: root

    required property var target
    property bool shift: false

    signal done

    function type(ch) {
        if (!target)
            return;
        target.insert(target.cursorPosition, shift ? ch.toUpperCase() : ch);
        shift = false;
    }
    function backspace() {
        if (target && target.cursorPosition > 0)
            target.remove(target.cursorPosition - 1, target.cursorPosition);
    }

    color: Theme.darkGray
    implicitHeight: 5 * 66 + 6 * 8

    component Key: Rectangle {
        id: key

        property string label: ""
        property real weight: 1
        property bool active: false
        property color accent: Theme.blue

        signal pressed

        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredWidth: weight * 100
        border.color: tap.pressed || active ? accent : Theme.darkGray3
        border.width: 2
        color: tap.pressed ? Theme.darkGray3 : (active ? Qt.darker(accent, 2.4) : Theme.darkGray2)
        radius: 10

        Text {
            anchors.centerIn: parent
            color: "white"
            font.bold: true
            font.pixelSize: 28
            text: key.label
        }
        TapHandler {
            id: tap

            gesturePolicy: TapHandler.ReleaseWithinBounds

            onPressedChanged: if (pressed) key.pressed()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Repeater {
            model: [
                ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü"],
                ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä"],
                ["y", "x", "c", "v", "b", "n", "m", "-", "."]
            ]

            RowLayout {
                id: row

                required property var modelData
                required property int index

                spacing: 8
                Layout.fillHeight: true
                Layout.fillWidth: true

                Key {
                    active: root.shift
                    label: "⇧"
                    visible: row.index === 3
                    weight: 1.5

                    onPressed: root.shift = !root.shift
                }
                Repeater {
                    model: row.modelData

                    Key {
                        required property string modelData

                        label: root.shift ? modelData.toUpperCase() : modelData

                        onPressed: root.type(modelData)
                    }
                }
                Key {
                    label: "⌫"
                    visible: row.index === 0
                    weight: 1.6

                    onPressed: root.backspace()
                }
            }
        }
        RowLayout {
            spacing: 8
            Layout.fillHeight: true
            Layout.fillWidth: true

            Key {
                label: "CLEAR"
                weight: 2

                onPressed: if (root.target) root.target.clear()
            }
            Key {
                label: "space"
                weight: 8

                onPressed: root.type(" ")
            }
            Key {
                accent: "#3ddc84"
                label: "DONE"
                weight: 2

                onPressed: root.done()
            }
        }
    }
}
