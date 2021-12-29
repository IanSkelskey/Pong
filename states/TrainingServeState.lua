TrainingServeState = Class{__includes = BaseState}

function TrainingServeState:init()
    ball:reset()
    player2Score = 0
end

function TrainingServeState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('training')
    end

    -- player2
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end
    ball.dy = math.random(-50, 50)
    ball.dx = -math.random(140, 200)
    servingPlayer = 2
	
    player2:update(dt)
end

function TrainingServeState:render()
    ball:render()
    wall:render()
    player2:render()
end