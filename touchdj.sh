#!/bin/sh
# Launch the touch DJ UI with its own settings/library (does not touch ~/.mixxx).
# Extra args (e.g. audio files) are passed through to Mixxx.
exec "$(dirname "$0")/build/mixxx" --new-ui --settingsPath "$HOME/.mixxx-dev" "$@"
