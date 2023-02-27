local vec2 = require("vec2")
local componentM= require("componentManager")
local entityM= require("entityManager")

function ApplyMovement(entity)
    local position = GetComponent(entity,ComponentTypes.Position)
    local velocity = GetComponent(entity,ComponentTypes.Velocity)
    local size = GetComponent(entity,ComponentTypes.Size)
    --local size = vec2.new(10,10)
    
    local sizeY= size.y
    local sizeX= size.x

    local nextStep = vec2.new(
        position.x + velocity.x,
        position.y + velocity.y)

    if nextStep.y >= WindowSize.y - sizeY then
        --moveComp.BecomeGrounded()
        nextStep.y = WindowSize.y - sizeY
    end

    if nextStep.x >= WindowSize.x - sizeX then
        nextStep.x = WindowSize.x - sizeX
    elseif nextStep.x <= 0 then
        nextStep.x = 0
    end
    SetComponent(entity,ComponentTypes.Position,nextStep)
end