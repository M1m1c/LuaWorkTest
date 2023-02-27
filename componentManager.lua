
--Component Type strings are defined here for ease of use
ComponentTypes=
{
  Position="position",
  Size="size",
  Input="input",
  Velocity="Velocity",
  Player="player",
  MoveForce="moveForce",
  Direction="Direction",
  Jump="Jump",
  Gravity="Gravity",
}

local components = {}
function AddComponent(entityId, componentType, componentData)

  if components[componentType] == nil then
    components[componentType] = {}
  end

  components[componentType][entityId] = componentData
end

function SetComponent(entityId, componentType, componentData)
  if components[componentType] ~= nil then
    components[componentType][entityId] = componentData
  end
end

function GetComponent(entityId, componentType)
  if components[componentType] ~= nil then
    return components[componentType][entityId]
  else
    return nil
  end
end

function RemoveComponent(entityId, componentType)
  components[componentType][entityId] = nil
end

return components