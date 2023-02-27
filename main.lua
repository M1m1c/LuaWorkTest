local Vec2 = require("vec2")
local entityM = require("entityManager")
local Player = require("playerSystems")
local Lmath = require("lmath")
local systems = require("systems")

local fixedDT = 0.02
local accumulatedFixedTime = 0

WindowSize = Vec2.new(800.0, 600.0)
local playerEntity = 0
function love.load()
    playerEntity = CreateEntity()
    PlayerLoad(playerEntity)
end

function love.update(dt)
    FixedUpdate(dt)
end

function FixedUpdate(dt)
    accumulatedFixedTime = accumulatedFixedTime + dt

    while accumulatedFixedTime >= fixedDT do
        
        for entityID in IterateEntitiesWithComponents({ ComponentTypes.Input, ComponentTypes.Direction }) do
            ReadInput(entityID)
        end

        PlayerUpdate(fixedDT)
        
        for entityID in IterateEntitiesWithComponents({ ComponentTypes.Position, ComponentTypes.Size, ComponentTypes.Velocity }) do
            ApplyMovement(entityID)
        end
        accumulatedFixedTime = accumulatedFixedTime - fixedDT
    end
end

function love.keypressed(key)

    local playerInput= GetComponent(playerEntity,ComponentTypes.Input)
    if key == "space" then
        playerInput.Jump.Current = true
    end

    if key == "d" or key == "right" then
        playerInput.Right.Current = true
    end

    if key == "a" or key == "left" then
        playerInput.Left.Current = true
    end
end

function love.keyreleased(key)
    
    local playerInput= GetComponent(playerEntity,ComponentTypes.Input)
    if key == "space" then
        playerInput.Jump.Current = false
    end

    if key == "d" or key == "right" then
        playerInput.Right.Current = false
    end

    if key == "a" or key == "left" then
        playerInput.Left.Current = false
    end
end

function love.draw()
    love.graphics.setColor(0, 200, 240)


    for entityId in IterateEntitiesWithComponents({ ComponentTypes.Position, ComponentTypes.Size }) do
        local position = GetComponent(entityId, ComponentTypes.Position)
        local size = GetComponent(entityId, ComponentTypes.Size)

        love.graphics.rectangle("fill", position.x, position.y, size.x, size.y)
    end

    love.graphics.print("player position Y:" .. GetComponent(playerEntity, ComponentTypes.Position).y, 0, 10)
    if GetComponent(playerEntity, ComponentTypes.Input).Jump.Current == true then
        love.graphics.print("Jump:" .. "true", 0, 20)
    else
        love.graphics.print("Jump:" .. "false", 0, 20)
    end
end
