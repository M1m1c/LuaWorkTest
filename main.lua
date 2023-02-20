Vec2 = require("vec2")
Player = require("player")
Gravity = 100.0
AccumulatedGravityAccel = 0.0

windowSize = Vec2.new(800.0, 600.0)

function love.load()
    Player.Position = Vec2.new(100, 0)
    Player.Size = Vec2.new(10, 10)
end

function love.update(dt)
    ApplyGravity(dt)
end

--TODO need to take in a table of entites
function ApplyGravity(dt)
    local gravityMultiplier = 3.5
    AccumulatedGravityAccel = AccumulatedGravityAccel + (dt * gravityMultiplier)
    local gravityStep = Gravity * AccumulatedGravityAccel * dt
    local nextStep = Player.Position.y + gravityStep

    if nextStep < windowSize.y - Player.Size.y then
        Player.Position.y = nextStep
    else
        Player.Position.y = windowSize.y - Player.Size.y
        AccumulatedGravityAccel = 0
    end
end

function love.keypressed(key)
    if key == "space" then
        Player.Input.Jump = true
    end
    if key == "d" or key == "right" then
        Player.Input.Right = true
    end
    if key == "a" or key == "left" then
        Player.Input.Left = true
    end
end

function love.keyreleased(key)
    if key == "space" then
        Player.Input.Jump = false
    end
    if key == "d" or key == "right" then
        Player.Input.Right = false
    end
    if key == "a" or key == "left" then
        Player.Input.Left = false
    end
end

function love.draw()
    love.graphics.rectangle("fill", Player.Position.x, Player.Position.y, Player.Size.x, Player.Size.y)
    love.graphics.print("player position Y:" .. Player.Position.y, 0, 10)
    love.graphics.print("AccumulatedGravityAccel:" .. AccumulatedGravityAccel, 0, 20)
end
