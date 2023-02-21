local vec2 = require("vec2")
local inputComp = require("inputComp")
local moveComp = require("movementComp")

local player = {
    Position = vec2.new(0, 0),
    Size = vec2.new(0, 0),
    Input = inputComp,
    MoveComp = moveComp
}

function player.Update(dt)
    ReadInput()
    player.MoveComp.ExtendJumpWithHeldButton(player.Input.Jump.Current, dt)
    player.MoveComp.JumpingAndFalling(player.Position.y, player.Size.y, dt)
    player.MoveComp.MoveInDirection(dt)
    ApplyMovement()
end

--TODO breakout funcitonality where we can pass a inputatom and two collections of funcitons, one to call when button is pressed and one when button is released
function ReadInput()
    local input = player.Input

    if input.Jump.Current == true and input.Jump.Old == false then
        input.Jump.Old = true

        player.MoveComp.InitiateJump()
    elseif input.Jump.Current == false and input.Jump.Old == true then
        input.Jump.Old = false
    end

    if input.Right.Current == true then
        moveComp.Direction = 1
    elseif input.Left.Current == true then
        moveComp.Direction = -1
    else
        moveComp.Direction = 0
    end
end

function ApplyMovement()
    local nextStep = vec2.new(player.Position.x + moveComp.Velocity.x, player.Position.y + moveComp.Velocity.y)
    if nextStep.y >= WindowSize.y - player.Size.y then
        player.MoveComp.BecomeGrounded()
        nextStep.y = WindowSize.y - player.Size.y
    end
    player.Position = nextStep
end

return player
