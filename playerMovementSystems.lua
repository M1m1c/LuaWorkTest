local vec2 = require("vec2")
local lMath = require("lmath")
local playerMoveComp = require("playerMoveComp")

local jumpForce = 0.0
local gravForce = 0.0
local moveForce = 0.0
local playerEntity = 0
local velocity
local directionComp 
local gravityComp 
local jumpComp
local MoveForceComp

function LoadPlayerMoveSystem(entityId)
    playerEntity = entityId
    velocity = GetComponent(playerEntity, ComponentTypes.Velocity)
    directionComp = GetComponent(playerEntity, ComponentTypes.Direction)
    gravityComp = GetComponent(playerEntity, ComponentTypes.Gravity)
    jumpComp = GetComponent(playerEntity,ComponentTypes.Jump)
    MoveForceComp = GetComponent(playerEntity,ComponentTypes.MoveForce)
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
        local resultForce = reductionForce + moveForce

        local isPositiveDir = directionComp.Dir > 0
        local isNewVelocityLess = moveForce + resultForce < 0.0

        if (isPositiveDir and isNewVelocityLess) or (not isPositiveDir and not isNewVelocityLess) then
            moveForce = 0.0
        else
            moveForce = moveForce + reductionForce
        end
    else
        local newStep = 0.0
        if directionComp.IsRecivingInput then
            newStep = dt * directionComp.Dir * directionComp.AccelerationSpeed
        end

        moveForce = moveForce + newStep

        local isRightDir = directionComp.Dir > 0
        local isVelocityLeft = moveForce < 0.0
        if (isRightDir and isVelocityLeft) or (not isRightDir and not isVelocityLeft) then
            moveForce = moveForce * -1
        end
    end
    moveForce = lMath.clamp(moveForce, -1.0, 1.0)
    MoveForceComp = moveForce
    velocity.x = moveForce * directionComp.MaxMoveSpeed
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

        jumpForce = jumpMagnitude

        jumpComp.JumpTimer = lMath.clamp(jumpComp.JumpTimer - dt, 0.0, jumpComp.MaxJumpTimer) --clamp this between 0 and max
    elseif gravityComp.IsGrounded == false then
        gravityComp.FallMomentum = gravityComp.FallMomentum + (dt * gravityComp.Weight)
        local gravityStep = gravityComp.Gravity * gravityComp.FallMomentum * dt
        gravForce = gravityStep
    else
        gravForce = 0.0
        jumpForce = 0.0
    end

    velocity.y = jumpForce + gravForce
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
    gravForce = 0.0
    jumpForce = 0.0
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