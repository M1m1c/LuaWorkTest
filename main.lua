Vec2 = require("vec2")
Player = require("player")

function love.load()
    Player.Position= Vec2.new(0,100)
end

function love.update(dt)
    ApplyGravity(dt)
end

--TODO need to take in a table of entites
function ApplyGravity(dt)
    local gravityStep= 100 * dt 
    local nextStep = Player.Position.y + gravityStep
   
    if nextStep < 400 then
        Player.Position.y= nextStep
    else 
        Player.Position.y = 400
    end
end

function love.draw()
love.graphics.rectangle("fill",Player.Position.x,Player.Position.y,10,10)
love.graphics.print("player position Y:" .. Player.Position.y, 0, 10)
end
