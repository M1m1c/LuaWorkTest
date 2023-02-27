local vec2 = require("vec2")
local inputComp = require("inputComp")
local playerMoveSystem = require("playerMovementSystems")
local componentM = require("componentManager")
local entityM = require("entityManager")
local systems = require("systems")

local entityID = 0

local player = {
    Position = vec2.new(0, 0),
    Size = vec2.new(0, 0),
    Input = inputComp,
    MoveComp = playerMoveSystem
}

function PlayerLoad(playerEntity)
    entityID = playerEntity
    AddComponent(playerEntity, ComponentTypes.Position, vec2.new(390, 0))
    AddComponent(playerEntity, ComponentTypes.Size, vec2.new(10, 10))
    AddComponent(playerEntity, ComponentTypes.Input, inputComp)
    AddComponent(playerEntity, ComponentTypes.Velocity, vec2.new(0, 0))
end

function PlayerUpdate(dt)
    local input = GetComponent(entityID, ComponentTypes.Input)

    ReadInput(input)
    playerMoveSystem.ExtendJumpWithHeldButton(inputComp.Jump.Current, dt)
    playerMoveSystem.JumpingAndFalling(player.Position.y, player.Size.y, dt)
    playerMoveSystem.MoveInDirection(dt)
    ApplyMovement(entityID)
end

--TODO breakout funcitonality where we can pass a inputatom and two collections of funcitons, one to call when button is pressed and one when button is released
function ReadInput(input)
    if input.Jump.Current == true and input.Jump.Old == false then
        input.Jump.Old = true
        playerMoveSystem.InitiateJump()
    elseif input.Jump.Current == false and input.Jump.Old == true then
        input.Jump.Old = false
        playerMoveSystem.DeInitiateJump()
    end

    if input.Right.Current == true then
        playerMoveSystem.DirectionComp.Dir = 1
    elseif input.Left.Current == true then
        playerMoveSystem.DirectionComp.Dir = -1
    end

    if input.Right.Current == false and input.Left.Current == false then
        playerMoveSystem.DirectionComp.IsRecivingInput = false
    else
        playerMoveSystem.DirectionComp.IsRecivingInput = true
    end
end

return player
