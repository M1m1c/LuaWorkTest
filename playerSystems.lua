local vec2 = require("vec2")
local inputComp = require("inputComp")
local directionComp = require("directionComp")
local jumpComp = require("jumpComp")
local gravityComp = require("gravityComp")
local forceComp = require("forceComp")
local playerMoveSystem = require("playerMovementSystems")

local entityID = 0

function PlayerLoad(playerEntity)
    entityID = playerEntity
    AddComponent(playerEntity, ComponentTypes.Position, vec2.new(390, 0))
    AddComponent(playerEntity, ComponentTypes.Size, vec2.new(10, 10))
    AddComponent(playerEntity, ComponentTypes.Input, inputComp)
    AddComponent(playerEntity, ComponentTypes.Velocity, vec2.new(0, 0))
    AddComponent(playerEntity, ComponentTypes.Player, true)
    AddComponent(playerEntity, ComponentTypes.Force, forceComp)
    AddComponent(playerEntity, ComponentTypes.Direction, directionComp )
    AddComponent(playerEntity, ComponentTypes.Jump, jumpComp )
    AddComponent(playerEntity, ComponentTypes.Gravity, gravityComp )

    LoadPlayerMoveSystem(playerEntity)
end

function PlayerUpdate(dt)
    local input = GetComponent(entityID, ComponentTypes.Input)
    local position = GetComponent(entityID, ComponentTypes.Position)
    local size = GetComponent(entityID, ComponentTypes.Position)

    --ReadInput(entityID)
    PlayerExtendJumpWithHeldButton(input.Jump.Current, dt)
    PlayerJumpingAndFalling(position.y, size.y, dt)
    PlayerMoveInDirection(dt)
   
end

