# Shift Lock (Ctrl)

A Roblox Studio script that enables "shift lock" camera control—where the camera rotates around your character like a turret while aiming—activated by holding either the Left Ctrl or Right Ctrl key.

## Install

1. Download or copy the contents of `src/ShiftLockCtrl.lua` from this repository.
2. Open your place in Roblox Studio.
3. In the Explorer panel, navigate to one of these locations:
   - `StarterPlayer` → `StarterPlayerScripts` (recommended)
   - `StarterPlayer` → `StarterCharacterScripts`
4. Right-click on the destination folder and select **Insert Object** → **LocalScript**.
5. Replace the default script content with the contents of `ShiftLockCtrl.lua`.

## Use

1. Playtest your game in Roblox Studio.
2. Move your character around using the standard WASD controls.
3. Hold down **Left Ctrl** or **Right Ctrl** to enter shift lock mode—the camera will lock onto the back of your character at a fixed distance.
4. While holding Ctrl, move the mouse to rotate the camera:
   - Left/right movement controls yaw (horizontal rotation).
   - Up/down movement controls pitch (vertical rotation), clamped to prevent clipping through walls or the floor.
5. Release Ctrl to return to the normal third-person camera.

The camera behavior is fully configurable at the top of the script:

- `SHIFT_LOCK_DISTANCE` — camera distance from the character (studs).
- `CAMERA_SPEED` — how fast the camera rotates (smoothing).
- `MOUSE_SENSITIVITY` — sensitivity of mouse movement.
- `MIN_PITCH` / `MAX_PITCH` — vertical rotation limits in radians.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/b5f013fb-32f7-4a32-8c78-ca5aefd0140a?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=b5f013fb-32f7-4a32-8c78-ca5aefd0140a
