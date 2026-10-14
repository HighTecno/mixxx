.pragma library

// Human-readable text for a control: linear gain -> dB, bipolar knobs -> +/-%, etc.
function kindFor(group, key) {
    if (key === "crossfader")
        return "xfade";
    if (key === "volume" || key === "pregain" || key === "gain" || key === "headGain")
        return "db";
    if (group.indexOf("[EqualizerRack") === 0 && /^parameter[123]$/.test(key))
        return "db";
    if (key === "super1" || key === "headMix" || key === "balance" || key === "rate")
        return "bipolar";
    return "percent";
}

function format(kind, value, parameter) {
    switch (kind) {
    case "db":
        if (!(value > 0.0005))
            return "-∞ dB";
        const db = 20 * Math.log(value) / Math.LN10;
        return (db > 0 ? "+" : "") + db.toFixed(1) + " dB";
    case "xfade": {
        const v = (parameter - 0.5) * 2;
        if (Math.abs(v) < 0.02)
            return "CENTER";
        return (v < 0 ? "◀ " : "") + Math.round(Math.abs(v) * 100) + (v > 0 ? " ▶" : "");
    }
    case "bipolar": {
        const v = Math.round((parameter - 0.5) * 200);
        return (v > 0 ? "+" : "") + v + "%";
    }
    default:
        return Math.round(parameter * 100) + "%";
    }
}
