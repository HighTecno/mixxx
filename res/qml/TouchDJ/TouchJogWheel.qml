import Mixxx 1.0 as Mixxx
import QtQuick
import "Tuning"
import "../Theme"

// Touch jogwheel.
//  - touch the inner platter  -> scratch (same scratch_position approach as the stock Spinny)
//  - touch the outer ring     -> pitch bend (accumulates into "jog")
// PointHandler is multi-touch aware, so both decks can be worked at the same time.
Item {
    id: root

    required property string group
    property color accent: Theme.blue
    // fraction of the radius below which a touch is a scratch, above it a bend
    property real ringStart: 0.74
    // jog units per radian of ring movement; tune on the device
    property real bendGain: JogTuning.bendGain
    // smoothing time constant in seconds: the finger position arrives at the
    // touch rate (60-120 Hz); we glide towards it once per display frame so the
    // audio sees continuous motion instead of steps. Lower = tighter, higher = smoother.
    property real smoothing: JogTuning.smoothing
    readonly property real diameter: Math.min(width, height)
    readonly property real rpm: vinylSpeed.value > 0 ? vinylSpeed.value : 33.33
    readonly property real rps: Math.PI * rpm / 60.0
    readonly property bool loaded: trackLoaded.value > 0
    readonly property bool positionDataValid: spinny.valid
        && isFinite(samples.value) && samples.value > 0
        && isFinite(sampleRate.value) && sampleRate.value > 0
    readonly property real angle: positionDataValid
        ? 360 * (rps / Math.PI) * (spinny.playPosition * (samples.value / 2) / sampleRate.value) % 1
        : 0

    Mixxx.SpinnyPosition {
        id: spinny

        group: root.group
    }
    Mixxx.ControlProxy {
        id: trackLoaded

        group: root.group
        key: "track_loaded"
    }
    Mixxx.ControlProxy {
        id: samples

        group: root.group
        key: "track_samples"
    }
    Mixxx.ControlProxy {
        id: sampleRate

        group: root.group
        key: "track_samplerate"
    }
    Mixxx.ControlProxy {
        id: vinylSpeed

        group: root.group
        key: "vinylcontrol_speed_type"
    }
    Mixxx.ControlProxy {
        id: scratchEnable

        group: root.group
        key: "scratch_position_enable"
    }
    Mixxx.ControlProxy {
        id: scratchPosition

        group: root.group
        key: "scratch_position"
    }
    Mixxx.ControlProxy {
        id: jog

        group: root.group
        key: "jog"
    }

    // outer ring (bend zone)
    Rectangle {
        anchors.centerIn: parent
        border.color: ph.active && ph.mode === "bend" ? root.accent : Theme.darkGray3
        border.width: 6
        color: Theme.darkGray4
        height: root.diameter
        radius: height / 2
        width: height
    }
    // platter (scratch zone)
    Rectangle {
        anchors.centerIn: parent
        border.color: ph.active && ph.mode === "scratch" ? root.accent : Theme.darkGray2
        border.width: 4
        color: ph.active && ph.mode === "scratch" ? "#26262a" : "#18181a"
        height: root.diameter * root.ringStart
        radius: height / 2
        width: height

        // rotating marker + grooves
        Item {
            anchors.fill: parent
            rotation: root.angle
            visible: root.loaded

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.accent
                height: parent.height * 0.22
                radius: 6
                width: 14
                y: parent.height * 0.05
            }
            Rectangle {
                anchors.centerIn: parent
                border.color: Theme.darkGray3
                border.width: 2
                color: "transparent"
                height: parent.height * 0.55
                radius: height / 2
                width: height
            }
        }
        Text {
            anchors.centerIn: parent
            color: Theme.midGray
            font.bold: true
            font.pixelSize: root.diameter * 0.06
            text: root.loaded ? "" : "NO TRACK"
        }
    }

    // glide towards the finger once per rendered frame
    FrameAnimation {
        running: ph.active && ph.mode !== ""

        onTriggered: {
            const a = 1 - Math.exp(-frameTime / Math.max(0.001, root.smoothing));
            if (ph.mode === "scratch") {
                ph.smoothPos += (ph.targetPos - ph.smoothPos) * a;
                scratchPosition.value = ph.smoothPos;
            } else {
                const take = ph.pendingBend * a;
                ph.pendingBend -= take;
                jog.value += take;
            }
        }
    }

    PointHandler {
        id: ph

        property string mode: ""
        property real lastAngle: 0
        // where the finger is (target) vs. what we have fed to the engine so far
        property real targetPos: 0
        property real smoothPos: 0
        property real pendingBend: 0

        function angleOf(pos) {
            return Math.atan2(pos.y - root.height / 2, pos.x - root.width / 2);
        }
        function normalize(d) {
            while (d > Math.PI)
                d -= 2 * Math.PI;
            while (d < -Math.PI)
                d += 2 * Math.PI;
            return d;
        }

        acceptedButtons: Qt.LeftButton
        enabled: root.loaded

        onActiveChanged: {
            if (active) {
                const pos = point.position;
                const r = Math.hypot(pos.x - root.width / 2, pos.y - root.height / 2);
                lastAngle = angleOf(pos);
                targetPos = 0;
                smoothPos = 0;
                pendingBend = 0;
                if (r > root.diameter / 2) {
                    mode = "";
                } else if (r < root.diameter / 2 * root.ringStart) {
                    mode = "scratch";
                    scratchPosition.value = 0;
                    scratchEnable.value = 1;
                } else {
                    mode = "bend";
                }
            } else {
                // hand over whatever the glide hasn't delivered yet, then let go
                if (mode === "scratch") {
                    scratchPosition.value = targetPos;
                    scratchEnable.value = 0;
                } else if (mode === "bend") {
                    jog.value += pendingBend;
                    pendingBend = 0;
                }
                mode = "";
            }
        }
        onPointChanged: {
            if (!active || mode === "")
                return;
            const a = angleOf(point.position);
            const delta = normalize(a - lastAngle);
            lastAngle = a;
            if (mode === "scratch") {
                if (root.rps > 0 && sampleRate.value > 0)
                    targetPos += delta * sampleRate.value / root.rps;
            } else {
                pendingBend += delta * root.bendGain;
            }
        }
    }
}
