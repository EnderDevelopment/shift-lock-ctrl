--!strict

--[[
	Shift Lock (Ctrl)
	---------------------------------------------------------------------------
	Place this script inside the Player's PlayerScripts or StarterPlayerScripts.

	This script makes the camera "shift lock" (aim/rotate around the character
	like a turret) while the Ctrl key is held down. Releasing Ctrl returns to
	the normal third-person camera.
--]]

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- The maximum distance (in studs) the camera can keep from the character
-- while shift locked. Set to a lower value to keep the camera closer.
local SHIFT_LOCK_DISTANCE = 8

-- How fast the camera rotates while the mouse is moved. Larger = snappier.
local CAMERA_SPEED = 10

-- Sensitivity multiplier applied to mouse movement while shift locked.
local MOUSE_SENSITIVITY = 0.003

-- Angle limits in radians (0 = straight in front of the character).
-- Keep small so the camera does not clip through walls or behind the character.
local MIN_PITCH = -math.rad(80)
local MAX_PITCH = math.rad(80)

local camera = workspace.CurrentCamera
local playerScripts = player:WaitForChild("PlayerScripts")

local shiftLockActive = false
local yaw = 0
local pitch = 0
local currentDistance = SHIFT_LOCK_DISTANCE

-- True while our in-built render connection is running.
local connectionActive = false

local function lerp(a, b, t)
	return a + (b - a) * t
end

local function getCharacter()
	return player.Character
end

local function resetAngles()
	yaw = 0
	pitch = 0
	currentDistance = SHIFT_LOCK_DISTANCE
end

local function onRenderStep(dt: number)
	local character = getCharacter()
	if not character or not character.PrimaryPart then
		return
	end

	local root = character.PrimaryPart
	local rootPosition = root.Position

	-- Smoothly re-adjust the distance to its target value.
	currentDistance = lerp(currentDistance, SHIFT_LOCK_DISTANCE, dt * 4)

	-- Yaw is applied around the character; we use the current camera yaw as
	-- the base so the world does not jump when shift lock is engaged.
	local baseYaw = camera.CFrame.Rotation
		:ToEulerAnglesYXZ()
	yaw = baseYaw

	local cameraCFrame = CFrame.new(rootPosition)
		* CFrame.Angles(0, yaw, 0)
		* CFrame.Angles(pitch, 0, 0)
		* CFrame.new(0, 0, currentDistance)

	camera.CFrame = cameraCFrame
end

local function onInputBegan(input: InputObject, gameProcessed: boolean)
	if gameProcessed then
		return
	end

	if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
		shiftLockActive = true

		if not connectionActive then
			camera.CameraType = Enum.CameraType.Scriptable
			game:GetService("RunService"):BindToRenderStep("ShiftLockCamera", Enum.RenderPriority.Camera.Value, onRenderStep)
			connectionActive = true
		end

		resetAngles()
	end
end

local function onInputEnded(input: InputObject, gameProcessed: boolean)
	if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
		shiftLockActive = false

		if connectionActive then
			game:GetService("RunService"):UnbindFromRenderStep("ShiftLockCamera")
			connectionActive = false
			camera.CameraType = Enum.CameraType.Custom
			camera.CameraSubject = player.Character and player.Character:FindFirstChild("Humanoid")
		end
	end
end

-- While shift locked, the mouse movement controls the camera rotation.
local function onInputChanged(input: InputObject)
	if not shiftLockActive then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Delta * MOUSE_SENSITIVITY
		yaw = yaw - delta.X * CAMERA_SPEED
		pitch = math.clamp(pitch - delta.Y * CAMERA_SPEED, MIN_PITCH, MAX_PITCH)
	end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)
UserInputService.InputChanged:Connect(onInputChanged)

-- If the player dies (character removed) we fall back to a normal camera.
player.CharacterAdded:Connect(function()
	if not shiftLockActive then
		camera.CameraType = Enum.CameraType.Custom
		camera.CameraSubject = player.Character and player.Character:FindFirstChild("Humanoid")
	end
end)
