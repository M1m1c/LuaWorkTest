Vec2 = require("vec2")
Player = require("player")
GravityConstant = 100.0
MaxJumpTimer= 0.4
JumpTimer =0.0
MaxJumpButtonHoldTimer =0.15
JumpButtonHoldTimer =0.0


windowSize = Vec2.new(800.0, 600.0)

function love.load()
    Player.Position = Vec2.new(390, 0)
    Player.Size = Vec2.new(10, 10)
    Player.GravityComp.Weight = 3.5
end

function love.update(dt)
    --ExtendJumpWithHeldButton(dt)
    JumpingAndFalling(dt)
end

function ExtendJumpWithHeldButton(dt)
    if Player.Input.Jump==true then
        return
    end
    --TODO find clamp function
	JumpButtonHoldTimer = love.math.clamp(JumpButtonHoldTimer + (dt * 0.7), 0.0, MaxJumpButtonHoldTimer)
	JumpTimer =JumpTimer +( (dt + JumpButtonHoldTimer) * 0.2);
end

--TODO need to take in a table of entites
function JumpingAndFalling(dt)
    local gravComp = Player.GravityComp
   
    
    if JumpTimer > 0.0 then
        local multi= JumpTimer*4
        local pow =multi*multi
        local jumpMagnitude = -GravityConstant * dt * pow;

        Player.Position.y = Player.Position.y + (jumpMagnitude)

        JumpTimer = JumpTimer - dt --clamp this between 0 and max
    elseif Player.Position.y < windowSize.y - Player.Size.y then

        gravComp.FallMomentum = gravComp.FallMomentum + (dt * gravComp.Weight)

        local gravityStep = GravityConstant * gravComp.FallMomentum * dt
        local nextStep = Player.Position.y + gravityStep

        Player.Position.y = nextStep

    else
        Player.Position.y = windowSize.y - Player.Size.y
        gravComp.FallMomentum = 0
        gravComp.IsGrounded=true
    end

    Player.GravityComp = gravComp
end

function love.keypressed(key)
    if key == "space" then
        Player.Input.Jump = true
        JumpTimer=MaxJumpTimer;
        Player.GravityComp.FallMomentum=0
    end
    if key == "d" or key == "right" then
        Player.Input.Right = true
    end
    if key == "a" or key == "left" then
        Player.Input.Left = true
    end
end

function love.keyreleased(key)
    if key == "space" then
        Player.Input.Jump = false
    end
    if key == "d" or key == "right" then
        Player.Input.Right = false
    end
    if key == "a" or key == "left" then
        Player.Input.Left = false
    end
end

function love.draw()
    love.graphics.rectangle("fill", Player.Position.x, Player.Position.y, Player.Size.x, Player.Size.y)
    love.graphics.print("player position Y:" .. Player.Position.y, 0, 10)
    love.graphics.print("FallMomentum:" .. Player.GravityComp.FallMomentum, 0, 20)
end
