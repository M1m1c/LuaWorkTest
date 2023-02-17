Vec2 = {}
Vec2.__index = Vec2

function Vec2.new(x, y)
    local self = setmetatable({}, Vec2)
    self.x = x or 0
    self.y = y or 0
    return self
  end

function Vec2.Add(a, b)
    if type(a) == "number" then
        return Vec2.new(b.x + a, b.y + a)
    elseif type(b) == "number" then
        return Vec2.new(a.x + b, a.y + b)
    else
        return Vec2.new(a.x + b.x, a.y + b.y)
    end
end

return Vec2