local vec2 = require("vec2")
local inputComp = require("inputComp")
local gravityComp = require("gravityComp")
local jumpComp = require("jumpComp")
local lMath = require("lmath")

local player = {
    Position = vec2.new(0, 0),
    Size = vec2.new(0, 0),
    RigidBody = vec2.new(0, 0),
    Input = inputComp,
    GravityComp = gravityComp,
    JumpComp = jumpComp
}
player.__index = player


function player.Update(dt)
    ReadInput()
    ExtendJumpWithHeldButton(player.Input.Jump.Current,dt)
    JumpingAndFalling(dt)
end

function ExtendJumpWithHeldButton(jumpInput,dt)
    local jComp = player.JumpComp
    if jumpInput == false then
        return
    elseif jComp.JumpButtonHoldTimer >= jComp.MaxJumpButtonHoldTimer then
        return
    else
        local temp = jComp.JumpButtonHoldTimer + (dt * 0.7)
        jComp.JumpButtonHoldTimer = lMath.clamp(temp, 0.0, jComp.MaxJumpButtonHoldTimer)
        jComp.JumpTimer = jComp.JumpTimer + ((dt + jComp.JumpButtonHoldTimer) * 0.2);
        player.JumpComp = jComp
    end
end

function JumpingAndFalling(dt)
    local gravComp = Player.GravityComp
    local jComp = player.JumpComp

    if jComp.JumpTimer > 0.0 then
        local jumpMagnitude = -gravComp.Gravity * dt * ((jComp.JumpTimer * 4) ^ 2);

        Player.Position.y = Player.Position.y + (jumpMagnitude)

        jComp.JumpTimer = lMath.clamp(jComp.JumpTimer - dt, 0.0, jComp.MaxJumpTimer) --clamp this between 0 and max
    elseif Player.Position.y < windowSize.y - Player.Size.y then
        gravComp.FallMomentum = gravComp.FallMomentum + (dt * gravComp.Weight)

        local gravityStep = gravComp.Gravity * gravComp.FallMomentum * dt
        local nextStep = Player.Position.y + gravityStep

        Player.Position.y = nextStep
    else
        Player.Position.y = windowSize.y - Player.Size.y
        gravComp.FallMomentum = 0
        gravComp.IsGrounded = true
    end

    Player.GravityComp = gravComp
    player.JumpComp = jComp
end

function InitiateJump()
    player.JumpComp.JumpTimer = MaxJumpTimer
    player.JumpComp.JumpButtonHoldTimer = 0.0
    player.GravityComp.FallMomentum = 0
end

function ReadInput()
    if player.Input.Jump.Current == true and player.Input.Jump.Old == false then
        player.Input.Jump.Old = true
       InitiateJump()
    elseif player.Input.Jump.Current == false and player.Input.Jump.Old == true then
        player.Input.Jump.Old = false
    end
end

return player
