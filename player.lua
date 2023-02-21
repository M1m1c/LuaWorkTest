local vec2 = require("vec2")
local inputComp = require("inputComp")

local moveComp = require("movementComp")

local lMath = require("lmath")

local player = {
    Position = vec2.new(0, 0),
    Size = vec2.new(0, 0),
    RigidBody = vec2.new(0, 0),
    Input = inputComp,
    MoveComp = moveComp
}
player.__index = player


function player.Update(dt)
    ReadInput()
    player.MoveComp.ExtendJumpWithHeldButton(player.Input.Jump.Current,dt)
    player.MoveComp.JumpingAndFalling(player.Position.y,player.Size.y,dt)
    ApplyMovement()
end

function ReadInput()
    if player.Input.Jump.Current == true and player.Input.Jump.Old == false then
        player.Input.Jump.Old = true
        player.MoveComp.InitiateJump()
    elseif player.Input.Jump.Current == false and player.Input.Jump.Old == true then
        player.Input.Jump.Old = false
    end
end

function ApplyMovement()
    local nextStep=vec2.new(player.Position.x + moveComp.Velocity.x, player.Position.y + moveComp.Velocity.y)
    if nextStep.y >= WindowSize.y - player.Size.y then
        player.MoveComp.BecomeGrounded()
        nextStep.y= WindowSize.y - player.Size.y 
    end
    player.Position=nextStep
end

return player
