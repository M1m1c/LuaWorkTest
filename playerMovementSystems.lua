local vec2 = require("vec2")
local lMath = require("lmath")

local playerEntity = 0
local velocity
local directionComp 
local gravityComp 
local jumpComp
local force

function LoadPlayerMoveSystem(entityId)
    playerEntity = entityId
    velocity = GetComponent(playerEntity, ComponentTypes.Velocity)
    directionComp = GetComponent(playerEntity, ComponentTypes.Direction)
    gravityComp = GetComponent(playerEntity, ComponentTypes.Gravity)
    jumpComp = GetComponent(playerEntity,ComponentTypes.Jump)
    force = GetComponent(playerEntity,ComponentTypes.Force)
end

--HORIZONTAL MOVEMENT
function PlayerMoveInDirection(dt)
   

    if directionComp.IsRecivingInput == false then
        local decelSpeed = 0
        if gravityComp.IsGrounded == true then
            decelSpeed = directionComp.DecelerationSpeed
        else
            decelSpeed = directionComp.DecelerationSpeed * 0.25
        end

        local reductionForce = (directionComp.Dir * -1) * decelSpeed * dt
        local resultForce = reductionForce + force.MoveForce

        local isPositiveDir = directionComp.Dir > 0
        local isNewVelocityLess = force.MoveForce + resultForce < 0.0

        if (isPositiveDir and isNewVelocityLess) or (not isPositiveDir and not isNewVelocityLess) then
            force.MoveForce = 0.0
        else
            force.MoveForce = force.MoveForce + reductionForce
        end
    else
        local newStep = 0.0
        if directionComp.IsRecivingInput then
            newStep = dt * directionComp.Dir * directionComp.AccelerationSpeed
        end

        force.MoveForce = force.MoveForce + newStep

        local isRightDir = directionComp.Dir > 0
        local isVelocityLeft = force.MoveForce < 0.0
        if (isRightDir and isVelocityLeft) or (not isRightDir and not isVelocityLeft) then
            force.MoveForce = force.MoveForce * -1
        end
    end
    force.MoveForce = lMath.clamp(force.MoveForce, -1.0, 1.0)
    velocity.x = force.MoveForce * directionComp.MaxMoveSpeed
end

--JUMPING
function PlayerExtendJumpWithHeldButton(jumpInput, dt)
   

    if jumpInput == false then
        return
    elseif jumpComp.JumpButtonHoldTimer >= jumpComp.MaxJumpButtonHoldTimer then
        return
    elseif jumpComp.AllowExtending then
        local temp = jumpComp.JumpButtonHoldTimer + (dt * 0.7)
        jumpComp.JumpButtonHoldTimer = lMath.clamp(temp, 0.0, jumpComp.MaxJumpButtonHoldTimer)
        jumpComp.JumpTimer = jumpComp.JumpTimer + ((dt + jumpComp.JumpButtonHoldTimer) * 0.2);
    end
end

function PlayerJumpingAndFalling(positionY, sizeY, dt)

    if jumpComp.JumpTimer > 0.0 then
        local jumpMagnitude = -jumpComp.JumpStrength * dt * ((jumpComp.JumpTimer * 4) ^ 2);

        
        force.JumpForce = jumpMagnitude

        jumpComp.JumpTimer = lMath.clamp(jumpComp.JumpTimer - dt, 0.0, jumpComp.MaxJumpTimer) --clamp this between 0 and max
    elseif gravityComp.IsGrounded == false then
        gravityComp.FallMomentum = gravityComp.FallMomentum + (dt * gravityComp.Weight)
        local gravityStep = gravityComp.Gravity * gravityComp.FallMomentum * dt
        force.GravForce = gravityStep
    else
        force.GravForce = 0.0
        force.JumpForce = 0.0
    end

    velocity.y = force.JumpForce + force.GravForce
end

function PlayerInitiateJump()

    if jumpComp.CurrentJumps == jumpComp.MaxJumps then
        return
    end
    jumpComp.AllowExtending = true
    jumpComp.JumpTimer = jumpComp.MaxJumpTimer
    jumpComp.JumpButtonHoldTimer = 0.0
    jumpComp.CurrentJumps = jumpComp.CurrentJumps + 1
    gravityComp.FallMomentum = 0
    gravityComp.IsGrounded = false
    force.GravForce = 0.0
    force.JumpForce = 0.0
end

function PlayerDeInitiateJump()
    jumpComp.AllowExtending = false
end

function PlayerBecomeGrounded()
    velocity.y = 0
    jumpComp.JumpTimer = 0
    jumpComp.CurrentJumps = 0
    gravityComp.FallMomentum = 0
    gravityComp.IsGrounded = true
end
