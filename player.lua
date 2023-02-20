local vec2 = require("vec2")

local player = {Position=vec2.new(0,0), RigidBody =vec2.new(0,0)}
player.__index = player
return player