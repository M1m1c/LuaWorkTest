
local directionComp = {
    Dir = 0.0,
    IsRecivingInput = false,
    MaxMoveSpeed=2.0,
    AccelerationSpeed = 5.0,
    DecelerationSpeed = 4.0
}

local gravityComp = {
    Gravity = 100.0,
    FallMomentum = 0.0,
    Weight = 5.5,
    IsGrounded = false,
}

local jumpComp = {
    JumpStrength =200.0,
    MaxJumpTimer = 0.3,
    JumpTimer = 0.0,
    MaxJumpButtonHoldTimer = 0.15,
    JumpButtonHoldTimer = 0.,
    AllowExtending=true,
    MaxJumps=2,
    CurrentJumps=0
}

local playerMoveComp = {
    DirectionComp = directionComp,
    GravityComp = gravityComp,
    JumpComp = jumpComp,
    MoveForce = 0.0
}

return playerMoveComp