local lmath = {}
-- Clamps a number to within a certain range.
function lmath.clamp(n, low, high) return math.min(math.max(low, n), high) end

return lmath