local vec2 = require("vec2")
local componentM = require("componentManager")
local entityM = require("entityManager")


function ReadInput(entityID)
    local input = GetComponent(entityID, ComponentTypes.Input)
    local direction = GetComponent(entityID, ComponentTypes.Direction)

    if input.Jump.Current == true and input.Jump.Old == false then
        input.Jump.Old = true

        local player = GetComponent(entityID, ComponentTypes.Player)
        if player ~= nil then
            PlayerInitiateJump()
        end
    elseif input.Jump.Current == false and input.Jump.Old == true then
        input.Jump.Old = false
        
        local player = GetComponent(entityID, ComponentTypes.Player)
        if player ~= nil then
            PlayerDeInitiateJump()
        end
    end

    if input.Right.Current == true then
        direction.Dir = 1
    elseif input.Left.Current == true then
        direction.Dir = -1
    end

    if input.Right.Current == false and input.Left.Current == false then
        direction.IsRecivingInput = false
    else
        direction.IsRecivingInput = true
    end
end

function ApplyMovement(entityID)
    local position = GetComponent(entityID, ComponentTypes.Position)
    local velocity = GetComponent(entityID, ComponentTypes.Velocity)
    local size = GetComponent(entityID, ComponentTypes.Size)
    --local size = vec2.new(10,10)

    local sizeY = size.y
    local sizeX = size.x

    local nextStep = vec2.new(
        position.x + velocity.x,
        position.y + velocity.y)

    if nextStep.y >= WindowSize.y - sizeY then
        local player = GetComponent(entityID, ComponentTypes.Player)
        if player ~= nil then
            PlayerBecomeGrounded()
        end

        nextStep.y = WindowSize.y - sizeY
    end

    if nextStep.x >= WindowSize.x - sizeX then
        nextStep.x = WindowSize.x - sizeX
    elseif nextStep.x <= 0 then
        nextStep.x = 0
    end
    SetComponent(entityID, ComponentTypes.Position, nextStep)
end
