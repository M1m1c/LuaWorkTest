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
    ApplyMovement()
end

--TODO breakout funcitonality where we can pass a inputatom and two collections of funcitons, one to call when button is pressed and one when button is released
function ReadInput()
    if player.Input.Jump.Current == true and player.Input.Jump.Old == false then
        player.Input.Jump.Old = true

        player.MoveComp.InitiateJump()
    elseif player.Input.Jump.Current == false and player.Input.Jump.Old == true then
        player.Input.Jump.Old = false
    end

    if player.Input.Left.Current == true and player.Input.Left.Old == false then
        player.Input.Left.Old = true

    elseif player.Input.Left.Current == false and player.Input.Left.Old == true then
        player.Input.Left.Old = false
    end

    if player.Input.Right.Current == true and player.Input.Right.Old == false then
        player.Input.Right.Old = true

    elseif player.Input.Right.Current == false and player.Input.Right.Old == true then
        player.Input.Right.Old = false
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
