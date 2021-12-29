PlayState = Class{__includes = BaseState}

function PlayState:update(dt)
	    -- detect ball collision with paddles, reversing dx if true and
        -- slightly increasing it, then altering the dy based on the position
        -- at which it collided, then playing a sound effect
        if ball:collides(player1) then

            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            player1:playHitSound()
        end
        if ball:collides(player2) then

            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            player2:playHitSound()
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

        -- if we reach the left or right edge of the screen, go back to serve
        -- and update the score and serving player
        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()

            -- if we've reached a score of 10, the game is over; set the
            -- state to done so we can show the victory message
            if player2Score == 10 then
                winningPlayer = 2
                gStateMachine:change('done')
            else
                gStateMachine:change('serve')
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()

            if player1Score == 10 then
                winningPlayer = 1
                gStateMachine:change('done')
            else
                gStateMachine:change('serve')
            end
        end

        if singlePlayer == true then


        -- CPU Controlled Paddle Max Difficulty
        -- paddles are 20 pixels high while balls are 4
        if difficulty == 'easy' then
          rand = math.random(1, 10)
          if ball.dx < 0 then
          --how to do and in lua?
              if player1.y + 8 > ball.y then
                if rand == 1 then
                  player1.dy = -PADDLE_SPEED
                end
              elseif player1.y + 12 < ball.y then
                if rand == 1 then
                  player1.dy = PADDLE_SPEED
                end
              else
                  player1.dy = 0
              end
          else
            --wait if ball is being sent
              player1.dy = 0
          end
        elseif difficulty == 'medium' then
          rand = math.random(1, 7)
          if ball.dx < 0 then
          --how to do and in lua?
              if player1.y + 8 > ball.y then
                if rand == 1 then
                  player1.dy = -PADDLE_SPEED
                end
              elseif player1.y + 12 < ball.y then
                if rand == 1 then
                  player1.dy = PADDLE_SPEED
                end
              else
                  player1.dy = 0
              end
          else
            --wait if ball is being sent
              player1.dy = 0
          end
        else
          rand = math.random(1, 2)
          if ball.dx < 0 then
          --how to do and in lua?
              if player1.y + 8 > ball.y then
                if rand == 1 then
                  player1.dy = -PADDLE_SPEED
                end
              elseif player1.y + 12 < ball.y then
                if rand == 1 then
                  player1.dy = PADDLE_SPEED
                end
              else
                  player1.dy = 0
              end
          else
            --wait if ball is being sent
            -- move like an easier CPU while sending
              player1.dy = 0
          end
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
    ball:update(dt)

end

function PlayState:render()
    if rand ~= nil then
      love.graphics.printf(rand, 10, 10, VIRTUAL_WIDTH, 'left')
    end
    player1:render()
    player2:render()
    ball:render()
end
