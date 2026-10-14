import QtQuick
import QtQuick.Layouts
import "../Theme"

// Full-screen effects: four units in a 2x2 grid.
Rectangle {
    color: Theme.backgroundColor

    GridLayout {
        anchors.fill: parent
        anchors.margins: 10
        columnSpacing: 10
        columns: 2
        rowSpacing: 10

        Repeater {
            model: 4

            EffectUnitPanel {
                required property int index

                unitNumber: index + 1
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }
    }
}
