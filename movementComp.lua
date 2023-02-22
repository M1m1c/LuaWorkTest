local vec2 = require("vec2")
local lMath = require("lmath")
local gravityComp = require("gravityComp")
local jumpComp = require("jumpComp")
local directionComp = require("directionComp")

local moveComp = {
    MoveVelocity = vec2.new(0.0, 0.0),
    DirectionComp = directionComp,
    GravityComp = gravityComp,
    JumpComp = jumpComp
}

local jumpForce = 0.0
local gravForce = 0.0

--HORIZONTAL MOVEMENT
function moveComp.MoveInDirection(dt)
    if directionComp.IsRecivingInput == false then
        local decelSpeed = 0
        if gravityComp.IsGrounded == true then
            decelSpeed = directionComp.DecelerationSpeed
        else
            decelSpeed = directionComp.DecelerationSpeed * 0.25
        end

        local reductionForce = (directionComp.Dir * -1) * decelSpeed * dt
        local resultForce = reductionForce + moveComp.MoveVelocity.x

        local isPositiveDir = directionComp.Dir>0
        local isNewvelocityLess=moveComp.MoveVelocity.x+resultForce<0.0

        if (isPositiveDir and isNewvelocityLess) or(not isPositiveDir and  not isNewvelocityLess) then
            moveComp.MoveVelocity.x=0.0
        else 
            moveComp.MoveVelocity.x=moveComp.MoveVelocity.x +reductionForce
        end
    else
        local step = 100.0 * dt * moveComp.DirectionComp.Dir
        moveComp.MoveVelocity.x = step
    end
end

--JUMPING
function moveComp.ExtendJumpWithHeldButton(jumpInput, dt)
    local jComp = moveComp.JumpComp
    if jumpInput == false then
        return
    elseif jComp.JumpButtonHoldTimer >= jComp.MaxJumpButtonHoldTimer then
        return
    else
        local temp = jComp.JumpButtonHoldTimer + (dt * 0.7)
        jComp.JumpButtonHoldTimer = lMath.clamp(temp, 0.0, jComp.MaxJumpButtonHoldTimer)
        jComp.JumpTimer = jComp.JumpTimer + ((dt + jComp.JumpButtonHoldTimer) * 0.2);
        moveComp.JumpComp = jComp
    end
end

function moveComp.JumpingAndFalling(positionY, sizeY, dt)
    local gravComp = moveComp.GravityComp
    local jComp = moveComp.JumpComp

    if jComp.JumpTimer > 0.0 then
        local jumpMagnitude = -gravComp.Gravity * dt * ((jComp.JumpTimer * 4) ^ 2);

        jumpForce = jumpMagnitude

        jComp.JumpTimer = lMath.clamp(jComp.JumpTimer - dt, 0.0, jComp.MaxJumpTimer) --clamp this between 0 and max
    elseif gravComp.IsGrounded == false then
        gravComp.FallMomentum = gravComp.FallMomentum + (dt * gravComp.Weight)
        local gravityStep = gravComp.Gravity * gravComp.FallMomentum * dt
        gravForce = gravityStep
    else
        gravForce = 0.0
        jumpForce = 0.0
    end

    moveComp.MoveVelocity.y = jumpForce + gravForce
    moveComp.GravityComp = gravComp
    moveComp.JumpComp = jComp
end

function moveComp.InitiateJump()
    moveComp.JumpComp.JumpTimer = moveComp.JumpComp.MaxJumpTimer
    moveComp.JumpComp.JumpButtonHoldTimer = 0.0
    moveComp.GravityComp.FallMomentum = 0
    moveComp.GravityComp.IsGrounded = false
    gravForce = 0.0
    jumpForce = 0.0
end

function moveComp.BecomeGrounded()
    moveComp.MoveVelocity.y = 0
    moveComp.JumpComp.JumpTimer = 0
    moveComp.GravityComp.FallMomentum = 0
    moveComp.GravityComp.IsGrounded = true
end

return moveComp
