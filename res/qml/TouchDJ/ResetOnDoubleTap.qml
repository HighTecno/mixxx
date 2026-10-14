import QtQuick

// Emits `triggered` on a double tap that tolerates normal finger jitter.
// Qt's own tapCount gives up as soon as the finger wobbles past the drag
// threshold (very common on a touchscreen), so count taps ourselves:
// two short-travel taps within `interval` ms.
TapHandler {
    id: root

    property int interval: 450
    // max finger travel (px) between press and release for it to count as a tap
    property real slop: 45
    property double lastTap: 0

    signal triggered

    // keep the tap alive even when a sibling DragHandler starts moving
    gesturePolicy: TapHandler.WithinBounds

    onTapped: eventPoint => {
        const dx = eventPoint.position.x - eventPoint.pressPosition.x;
        const dy = eventPoint.position.y - eventPoint.pressPosition.y;
        if (Math.hypot(dx, dy) > slop) {
            lastTap = 0;
            return;
        }
        const now = Date.now();
        if (now - lastTap < interval) {
            lastTap = 0;
            triggered();
        } else {
            lastTap = now;
        }
    }
}
