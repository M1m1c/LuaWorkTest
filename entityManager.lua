local componentM = require("componentManager")

local entities = {}

function CreateEntity()
  local entityId = #entities + 1

  entities[entityId] = true

  return entityId
end

function DestroyEntity(entityId)
  entities[entityId] = nil

  for componentName, componentTable in pairs(componentM) do
    componentTable[entityId] = nil
  end
end

function IterateEntities()
  local index = 0
  return function()
    index = index + 1
    return entities[index]
  end
end

function IterateEntitiesWithComponents(componentTypes)
  local index = 0
  return function()
    while index < #entities do
      index = index + 1
      local entityId = index
      local hasComponents = true
      for _, componentType in ipairs(componentTypes) do
        if not GetComponent(entityId, componentType) then
          hasComponents = false
          break
        end
      end
      if hasComponents then
        return entityId
      end
    end
    return nil
  end
end

return entities
