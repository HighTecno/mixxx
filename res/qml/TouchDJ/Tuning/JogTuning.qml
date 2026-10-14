pragma Singleton
import Mixxx 1.0 as Mixxx
import QtCore
import QtQuick

// Jogwheel feel, adjustable live from the JOG popup and saved in the profile folder.
QtObject {
    id: root

    readonly property real defaultSmoothing: 0.025
    readonly property real defaultBendGain: 2.2

    // seconds; time constant of the glide towards the finger
    property real smoothing: defaultSmoothing
    // jog units per radian of outer-ring movement
    property real bendGain: defaultBendGain

    function resetDefaults() {
        smoothing = defaultSmoothing;
        bendGain = defaultBendGain;
    }

    property Settings store: Settings {
        category: "jog"
        location: Mixxx.Application.settingsDirectoryUrl + "/touchdj.ini"

        property alias bendGain: root.bendGain
        property alias smoothing: root.smoothing
    }
}
