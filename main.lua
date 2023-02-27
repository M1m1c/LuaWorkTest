local Vec2 = require("vec2")
local entityM = require("entityManager")
local Player = require("player")
local Lmath = require("lmath")

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
        
        for entityId in IterateEntitiesWithComponents({ ComponentTypes.Input, ComponentTypes.Direction }) do
            ReadInput(entityId)
        end
        
        PlayerUpdate(fixedDT)
        
        for entityId in IterateEntitiesWithComponents({ ComponentTypes.Position, ComponentTypes.Size, ComponentTypes.Velocity }) do
            ApplyMovement(entityId)
        end
        accumulatedFixedTime = accumulatedFixedTime - fixedDT
    end
end

function love.keypressed(key)
    if key == "space" then
        Player.Input.Jump.Current = true
    end

    if key == "d" or key == "right" then
        Player.Input.Right.Current = true
    end

    if key == "a" or key == "left" then
        Player.Input.Left.Current = true
    end
end

function love.keyreleased(key)
    if key == "space" then
        Player.Input.Jump.Current = false
    end

    if key == "d" or key == "right" then
        Player.Input.Right.Current = false
    end

    if key == "a" or key == "left" then
        Player.Input.Left.Current = false
    end
end

function love.draw()
    love.graphics.setColor(0, 200, 240)


    for entityId in IterateEntitiesWithComponents({ ComponentTypes.Position, ComponentTypes.Size }) do
        local position = GetComponent(entityId, ComponentTypes.Position)
        local size = GetComponent(entityId, ComponentTypes.Size)

        love.graphics.rectangle("fill", position.x, position.y, size.x, size.y)
    end

    love.graphics.print("player position Y:" .. Player.Position.y, 0, 10)
    if Player.Input.Jump.Current == true then
        love.graphics.print("Jump:" .. "true", 0, 20)
    else
        love.graphics.print("Jump:" .. "false", 0, 20)
    end
    --love.graphics.print("moveForce: " .. Player.MoveComp.MoveForce, 0, 30)
end
