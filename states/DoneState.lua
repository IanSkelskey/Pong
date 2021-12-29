DoneState = Class{__includes = BaseState}

function DoneState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- game is simply in a restart phase here, but will set the serving
        -- player to the opponent of whomever won for fairness!
        gStateMachine:change('serve')

        ball:reset()

        -- reset scores to 0
        player1Score = 0
        player2Score = 0

        -- decide serving player as the opposite of who won
        if winningPlayer == 1 then
            servingPlayer = 2
        else
            servingPlayer = 1
        end
    end
end

function DoneState:render()
    -- UI messages
    love.graphics.setFont(largeFont)
    love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
        0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
end