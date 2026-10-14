import QtQuick
import QtQuick.Layouts
import "../Theme"

// 16 samplers, 8 per page. LOAD loads the track currently selected in the library
// (the view jumps to the library so you can select one first).
Rectangle {
    id: root

    property bool secondPage: false

    // emitted so the window can open the library with this sampler as load target
    signal pickTrackFor(int sampler)

    color: Theme.backgroundColor

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        GridLayout {
            columnSpacing: 10
            columns: 4
            rowSpacing: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

            Repeater {
                model: 8

                SamplerCard {
                    required property int index

                    number: index + 1 + (root.secondPage ? 8 : 0)
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    onLoadRequested: root.pickTrackFor(number)
                }
            }
        }
        NavButton {
            label: root.secondPage ? "SAMPLERS 1 – 8" : "SAMPLERS 9 – 16"
            Layout.preferredHeight: 70
            Layout.preferredWidth: 360

            onActivated: root.secondPage = !root.secondPage
        }
    }
}
