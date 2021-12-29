ServeState = Class{__includes = BaseState}

function ServeState:init()
    -- re-center ball
    ball:reset()
        -- before switching to play, initialize ball's velocity based
    -- on player who last scored
    ball.dy = math.random(-50, 50)
    if servingPlayer == 1 then
        ball.dx = math.random(140, 200)
    else
        ball.dx = -math.random(140, 200)
    end
end

function ServeState:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
    --
    -- paddles can move no matter what state we're in
    --
    if singlePlayer == true then
        -- CPU
        --paddles are 20 pixels high while balls are 4
        if ball.dx < 0 then
        --how to do and in lua?
            if player1.y + 8 > ball.y then
                player1.dy = -PADDLE_SPEED
            elseif player1.y + 12 < ball.y then
                player1.dy = PADDLE_SPEED
            else
                player1.dy = 0
            end
        else
            player1.dy = 0
        end

        -- player2
        if love.keyboard.isDown('up') then
            player2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            player2.dy = PADDLE_SPEED
        else
            player2.dy = 0
        end
    else
        -- Player1
        if love.keyboard.isDown('w') then
            player1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            player1.dy = PADDLE_SPEED
        else
            player1.dy = 0
        end
        -- player2
        if love.keyboard.isDown('up') then
            player2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            player2.dy = PADDLE_SPEED
        else
            player2.dy = 0
        end
    end

    player1:update(dt)
    player2:update(dt)
end

function ServeState:render()
    -- UI messages
    love.graphics.setFont(smallFont)
    love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
        0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    player1:render()
    player2:render()
    ball:render()
end