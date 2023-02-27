local vec2 = require("../vec2")
local inputComp = require("components/inputComp")
local directionComp = require("components/directionComp")
local jumpComp = require("components/jumpComp")
local gravityComp = require("components/gravityComp")
local forceComp = require("components/forceComp")
local playerMoveSystem = require("systems/playerMovementSystems")

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

