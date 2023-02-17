
function love.load()
    Vec2 = require("vec2")
    Position= Vec2.new(0,100)
end

function love.update(dt)
Position.x = Position.x +(dt*100)
end

function love.draw()
love.graphics.rectangle("fill",Position.x,Position.y,100,100)
end
