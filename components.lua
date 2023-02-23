
local components = {}
function AddComponent(entityId, componentType, componentData)
  
  if not components[componentType] then
    components[componentType] = {}
  end

  components[componentType][entityId] = componentData
end

function GetComponent(entityId, componentType)
  return components[componentType][entityId]
end

function RemoveComponent(entityId, componentType)
  components[componentType][entityId] = nil
end

return components