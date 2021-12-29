TrainingState = Class{__includes = BaseState}

function TrainingState:update(dt)
    -- player2
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    if ball:collides(wall) then
        ball.dx = -ball.dx * 1.03
        ball.x = wall.x + 10
            
        -- keep velocity going in the same direction, but randomize it
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end

        sounds['wall_hit']:play()
    end
    if ball:collides(player2) then
        ball.dx = -ball.dx * 1.03
        ball.x = player2.x - 4
        player2Score = player2Score + 1
        -- keep velocity going in the same direction, but randomize it
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end

        sounds['paddle_hit']:play()
        sounds['score2']:play()
    end

    if ball.x > VIRTUAL_WIDTH then
        sounds['score']:play()

        gStateMachine:change('training-serve')
        
    end

    -- detect upper and lower screen boundary collision, playing a sound
    -- effect and reversing dy if true
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
        sounds['wall_hit']:play()
    end

    -- -4 to account for the ball's size
    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.y = VIRTUAL_HEIGHT - 4
        ball.dy = -ball.dy
        sounds['wall_hit']:play()
    end

	ball:update(dt)
    player2:update(dt)
end

function TrainingState:render()
    wall:render()
    ball:render()
    player2:render()
end