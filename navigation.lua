-- Controls navigating around open applications and spaces

--
-- Housekeeping
--

scriptId = "com.boztalay.myo.navigation"

function onForegroundWindowChange(app, title)
	-- We want to always be active, navigation sleeps for nothing
    return true
end

function activeAppName()
    return "Navigation"
end

--
-- Functionality
--

-- Set up

-- Locking state
isLocked = true
lastUnlockTime = 0
UNLOCK_TIMEOUT = 2500
unlockGesture = "thumbToPinky"

-- Control gestures
switchSpaceRightGesture = "waveOut"
switchSpaceLeftGesture = "waveIn"

function onActiveChange(isActive)
	if isActive then
		if myo.getArm() == "left" then
			temp = switchSpaceRightGesture
			switchSpaceRightGesture = switchSpaceLeftGesture
			switchSpaceLeftGesture = temp
		end
	end
end

-- Handling poses

function extendUnlock()
	lastUnlockTime = myo.getTimeMilliseconds()
end

function handleUnlock()
	myo.debug("Handling unlock gesture")

	extendUnlock()
	isLocked = false
end

function handleSwitchSpaceRight()
	myo.debug("Handling switch space right gesture")

	extendUnlock()
	myo.keyboard("right_arrow", "press", "control")
end

function handleSwitchSpaceLeft()
	myo.debug("Handling switch space left gesture")

	extendUnlock()
	myo.keyboard("left_arrow", "press", "control")
end

function onPoseEdge(pose, edge)
	if edge == "off" then
		return
	end

	if pose == unlockGesture then
		handleUnlock()
	end

	if isLocked then
		return
	end
	
	if pose == switchSpaceRightGesture then
		handleSwitchSpaceRight()
	elseif pose == switchSpaceLeftGesture then
		handleSwitchSpaceLeft()
	end
end

-- Handling timing

function onPeriodic()
	if not isLocked then
		if myo.getTimeMilliseconds() - lastUnlockTime > UNLOCK_TIMEOUT then
			myo.debug("Unlock timed out")
			isLocked = true
		end
	end
end
