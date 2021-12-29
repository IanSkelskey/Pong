DifficultySelectState = Class{__includes = BaseState}

-- Initialize Menu Selection to 1 ("Easy")
selection = 1

function DifficultySelectState:update(dt)
    
    -- chooses a game mode
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if selection == 1 then
                difficulty = 'easy'
                gStateMachine:change('serve')
            elseif selection == 2 then
                difficulty = 'medium'
                gStateMachine:change('serve')
            elseif selection == 3 then
                difficulty = 'hard'
                gStateMachine:change('serve')
            end
    end

    if love.keyboard.wasPressed('up') then
        sounds['paddle_hit']:play()
        if selection == 1 then
            selection = 3
        else
            selection = selection - 1
        end
    elseif love.keyboard.wasPressed('down') then
        sounds['paddle_hit']:play()
        if selection == 3 then
            selection = 1
        else
            selection = selection + 1
        end
    end
end

function DifficultySelectState:render()
    -- UI messages
    love.graphics.setFont(scoreFont)
    love.graphics.printf('Difficulty Selection', 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Use the arrow keys to choose an option and press Enter to begin!', 0, 10, VIRTUAL_WIDTH, 'center')
    --Mode Selection
    love.graphics.printf('Easy', 0, 190, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Medium', 0, 200, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Hard', 0, 210, VIRTUAL_WIDTH, 'center')

    if selection == 1 then
        love.graphics.printf('>>', 180, 190, VIRTUAL_WIDTH, 'left')
    elseif selection == 2 then
        love.graphics.printf('>>', 180, 200, VIRTUAL_WIDTH, 'left')
    elseif selection == 3 then
        love.graphics.printf('>>', 180, 210, VIRTUAL_WIDTH, 'left')
    end
end