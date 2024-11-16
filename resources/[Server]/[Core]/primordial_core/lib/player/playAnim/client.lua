---@alias animationFlags number
---| 0 DEFAULT
---| 1 LOOPING
---| 2 HOLD_LAST_FRAME
---| 4 REPOSITION_WHEN_FINISHED
---| 8 NOT_INTERRUPTABLE
---| 16 UPPERBODY
---| 32 SECONDARY
---| 64 REORIENT_WHEN_FINISHED
---| 128 ABORT_ON_PED_MOVEMENT
---| 256 ADDITIVE
---| 512 TURN_OFF_COLLISION
---| 1024 OVERRIDE_PHYSICS
---| 2048 IGNORE_GRAVITY
---| 4096 EXTRACT_INITIAL_OFFSET
---| 8192 EXIT_AFTER_INTERRUPTED
---| 16384 TAG_SYNC_IN
---| 32768 TAG_SYNC_OUT
---| 65536 TAG_SYNC_CONTINUOUS
---| 131072 FORCE_START
---| 262144 USE_KINEMATIC_PHYSICS
---| 524288 USE_MOVER_EXTRACTION
---| 1048576 HIDE_WEAPON
---| 2097152 ENDS_IN_DEAD_POSE
---| 4194304 ACTIVATE_RAGDOLL_ON_COLLISION
---| 8388608 DONT_EXIT_ON_DEATH
---| 16777216 ABORT_ON_WEAPON_DAMAGE
---| 33554432 DISABLE_FORCED_PHYSICS_UPDATE
---| 67108864 PROCESS_ATTACHMENTS_ON_START
---| 134217728 EXPAND_PED_CAPSULE_FROM_SKELETON
---| 268435456 USE_ALTERNATIVE_FP_ANIM
---| 536870912 BLENDOUT_WRT_LAST_FRAME
---| 1073741824 USE_FULL_BLENDING

---@alias animationControlFlags number
---| 0 NONE
---| 1 DISABLE_LEG_IK
---| 2 DISABLE_ARM_IK
---| 4 DISABLE_HEAD_IK
---| 8 DISABLE_TORSO_IK
---| 16 DISABLE_TORSO_REACT_IK
---| 32 USE_LEG_ALLOW_TAGS
---| 64 USE_LEG_BLOCK_TAGS
---| 128 USE_ARM_ALLOW_TAGS
---| 256 USE_ARM_BLOCK_TAGS
---| 512 PROCESS_WEAPON_HAND_GRIP
---| 1024 USE_FP_ARM_LEFT
---| 2048 USE_FP_ARM_RIGHT
---| 4096 DISABLE_TORSO_VEHICLE_IK
---| 8192 LINKED_FACIAL

--- Play an animation for a given player or ped.
--- @param pedId number The ID of the ped entity to play the animation on.
--- @param animDictionary string The animation dictionary.
--- @param animName string The name of the animation.
--- @param blendInSpeed? number The speed at which the animation blends in (defaults to 8.0).
--- @param blendOutSpeed? number The speed at which the animation blends out (defaults to -8.0).
--- @param animDuration? integer The duration of the animation in milliseconds (defaults to -1 for infinite).
--- @param animationFlags? AnimationFlags Flags for controlling the animation (defaults to 0).
--- @param startPhase? number The starting phase of the animation (defaults to 0.0).
--- @param isPhaseControlled? boolean Whether the animation phase is controlled externally (defaults to false).
--- @param animationControlFlags? ControlFlags Additional control flags for the animation (defaults to 0).
--- @param shouldOverrideCloneUpdate? boolean Whether to override clone update for the animation (defaults to false).
--- @return boolean success True if the animation played successfully, false otherwise.
function PL.Player.PlayAnimation(pedId, animDictionary, animName, blendInSpeed, blendOutSpeed, animDuration, animationFlags, startPhase, isPhaseControlled, animationControlFlags, shouldOverrideCloneUpdate)
    PL.Type.AssertType(pedId, "number")
    PL.Type.AssertType(animDictionary, "string")
    PL.Type.AssertType(animName, "string")
    PL.Type.AssertType(blendInSpeed, { "number", "nil" })
    PL.Type.AssertType(blendOutSpeed, { "number", "nil" })
    PL.Type.AssertType(animDuration, { "number", "nil" })
    PL.Type.AssertType(animationFlags, { "number", "nil" })
    PL.Type.AssertType(startPhase, { "number", "nil" })
    PL.Type.AssertType(isPhaseControlled, { "boolean", "nil" })
    PL.Type.AssertType(animationControlFlags, { "number", "nil" })
    PL.Type.AssertType(shouldOverrideCloneUpdate, { "boolean", "nil" })

    if not DoesEntityExist(pedId) or not IsEntityAPed(pedId) then
        PL.Print.Log(3, false, ("Invalid ped entity: %s."):format(tostring(pedId)))
        return false
    end

    if not lib.requestAnimDict(animDictionary) then
        PL.Print.Log(3, false, ("Failed to load animation dictionary: %s."):format(animDictionary))
        return false
    end

    local blendIn <const> = blendInSpeed or 8.0
    local blendOut <const> = blendOutSpeed or -8.0
    local duration <const> = animDuration or -1
    local animFlag <const> = animationFlags or 0
    local phase <const> = startPhase or 0.0
    local phaseControl <const> = isPhaseControlled or false
    local controlFlag <const> = animationControlFlags or 0
    local overrideClone <const> = shouldOverrideCloneUpdate or false

    TaskPlayAnim(pedId, animDictionary, animName, blendIn, blendOut, duration, animFlag, phase, phaseControl, controlFlag, overrideClone)

    if not IsEntityPlayingAnim(pedId, animDictionary, animName, 3) then
        PL.Print.Log(3, false, ("Failed to play animation '%s' from dictionary '%s' on ped: %s."):format(animName, animDictionary, tostring(pedId)))
        RemoveAnimDict(animDictionary)
        return false
    end

    RemoveAnimDict(animDictionary)
    PL.Print.Log(1, false, ("Animation '%s' from dictionary '%s' started successfully on ped: %s."):format(animName, animDictionary, tostring(pedId)))
    return true
end

return PL.Player.PlayAnimation