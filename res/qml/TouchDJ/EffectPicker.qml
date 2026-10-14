import Mixxx 1.0 as Mixxx
import QtQuick
import QtQuick.Controls
import "../Theme"

// Big-row popup list for choosing an effect for a slot.
Popup {
    id: root

    property var slot

    anchors.centerIn: Overlay.overlay
    height: Math.min(900, Overlay.overlay ? Overlay.overlay.height - 80 : 900)
    modal: true
    padding: 12
    width: 620

    background: Rectangle {
        border.color: Theme.darkGray3
        border.width: 3
        color: Theme.darkGray
        radius: 16
    }

    ListView {
        anchors.fill: parent
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        model: Mixxx.EffectsManager.visibleEffectsModel
        spacing: 6

        header: Rectangle {
            color: root.slot && root.slot.effectId === "" ? Theme.darkGray3 : Theme.darkGray2
            height: 84
            radius: 10
            width: ListView.view.width

            Text {
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 28
                text: "— none —"
            }
            TapHandler {
                onTapped: {
                    root.slot.effectId = "";
                    root.close();
                }
            }
        }
        delegate: Rectangle {
            required property string display
            required property string effectId
            readonly property string fxId: effectId

            readonly property bool isSeparator: display === "---" || effectId === ""

            color: root.slot && root.slot.effectId === fxId ? Theme.darkGray3 : Theme.darkGray2
            height: isSeparator ? 14 : 84
            radius: 10
            width: ListView.view.width

            Text {
                anchors.fill: parent
                anchors.margins: 16
                visible: !parent.isSeparator
                color: "white"
                elide: Text.ElideRight
                font.pixelSize: 28
                text: parent.display
                verticalAlignment: Text.AlignVCenter
            }
            TapHandler {
                enabled: !parent.isSeparator

                onTapped: {
                    root.slot.effectId = parent.fxId;
                    root.close();
                }
            }
        }
    }
}
