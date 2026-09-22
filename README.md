## Round 2 Bug Fixes

### Bug 1 - Scope Failure
All buttons were using the same `isPressed` value. I fixed it by giving each `TactileButton` its own private `isPressed` state.

### Bug 2 - Silent Mutator
The slider value was changing but the screen was not updating. I fixed it by putting the `powerLevel` change inside `setState()`.

### Bug 3 - Geometry Inversion
The pressed and unpressed shadows were reversed. I fixed it so the pressed button uses smaller shadows and the released button uses bigger shadows.

### Bug 4 - Event Race
The button action was happening during `onTapDown`. I fixed it so the button changes state on touch down, but the action runs on `onTapUp`.