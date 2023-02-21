local vec2 = require("vec2")
local lMath = require("lmath")
local gravityComp = require("gravityComp")
local jumpComp = require("jumpComp")

local moveComp = {
    Velocity = vec2.new(0.0, 0.0),
    GravityComp = gravityComp,
    JumpComp = jumpComp
}

local jumpForce = 0.0
local gravForce = 0.0

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

    moveComp.Velocity.y = jumpForce + gravForce
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
    moveComp.Velocity.y = 0
    moveComp.JumpComp.JumpTimer = 0
    moveComp.GravityComp.FallMomentum = 0
    moveComp.GravityComp.IsGrounded = true
end

return moveComp
