local vec2 = require("vec2")
local inputComp = require("inputComp")
local gravityComp = require("gravityComp")

local player = { Position = vec2.new(0, 0), Size = vec2.new(0, 0), RigidBody = vec2.new(0, 0), Input = inputComp,
    GravityComp = gravityComp }
player.__index = player
return player
