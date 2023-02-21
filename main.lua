Vec2 = require("vec2")
Player = require("player")
Lmath = require("lmath")
GravityConstant = 100.0
MaxJumpTimer = 0.4
JumpTimer = 0.0
MaxJumpButtonHoldTimer = 0.15
JumpButtonHoldTimer = 0.0


windowSize = Vec2.new(800.0, 600.0)

function love.load()
    Player.Position = Vec2.new(390, 0)
    Player.Size = Vec2.new(10, 10)
    Player.GravityComp.Weight = 3.5
end

function love.update(dt)
    Player.Update(dt)
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
    love.graphics.rectangle("fill", Player.Position.x, Player.Position.y, Player.Size.x, Player.Size.y)
    love.graphics.print("player position Y:" .. Player.Position.y, 0, 10)
    if Player.Input.Jump.Current==true then
        love.graphics.print("Jump:" .. "true", 0, 20)
        else
            love.graphics.print("Jump:" .. "false", 0, 20)
    end
   
end
