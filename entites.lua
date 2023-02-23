local components = require("components")

local entities = {}

function CreateEntity()
  local entityId = #entities + 1
  
  entities[entityId] = true
  
  return entityId
end

function DestroyEntity(entityId)
    entities[entityId] = nil
    
    for componentName, componentTable in pairs(components) do
      componentTable[entityId] = nil
    end
  end

function IterateEntities()
  local index = 0
  return function ()
    index = index + 1
    return entities[index]
  end
end

return entities