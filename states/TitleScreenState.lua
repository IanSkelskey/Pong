TitleScreenState = Class{__includes = BaseState}

-- Initialize Menu Selection to 1 ("Single Player Game")
selection = 1

function sleep(n)
    if n > 0 then
        os.execute("ping -n " .. tonumber(n+1) .. " localhost > NUL")
    end
end

function TitleScreenState:init()

end

function TitleScreenState:update(dt)

    music['bass-loop']:setLooping(true)
    --print('current: ')
    --print(music['intro-chord']:tell())
    --print('duration')
    print(music['intro-chord']:getDuration())
    if music['intro-chord']:tell() == 0 then
        music['intro-chord']:stop()
        music['bass-loop']:play()
    end

    -- chooses a game mode
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if selection == 1 then
                singlePlayer = true
                gStateMachine:change('difficulty')
            elseif selection == 2 then
                singlePlayer = false
                gStateMachine:change('serve')
            elseif selection == 3 then
                gStateMachine:change('training-serve')
            elseif selection == 4 then
                gStateMachine:change('settings')
            end
    end

    if love.keyboard.wasPressed('up') then
        sounds['paddle_hit']:play()
        if selection == 1 then
            selection = 4
        else
            selection = selection - 1
        end
    elseif love.keyboard.wasPressed('down') then
        sounds['paddle_hit']:play()
        if selection == 4 then
            selection = 1
        else
            selection = selection + 1
        end
    end
end

function TitleScreenState:render()
    -- UI messages
    love.graphics.setFont(scoreFont)
    love.graphics.printf('Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Use the arrow keys to choose an option and press Enter to begin!', 0, 10, VIRTUAL_WIDTH, 'center')
    --Mode Selection
    love.graphics.printf('1-Player', 0, 190, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('2-Player', 0, 200, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Training', 0, 210, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Settings', 0, 220, VIRTUAL_WIDTH, 'center')

    if selection == 1 then
        love.graphics.printf('>>', 180, 190, VIRTUAL_WIDTH, 'left')
    elseif selection == 2 then
        love.graphics.printf('>>', 180, 200, VIRTUAL_WIDTH, 'left')
    elseif selection == 3 then
        love.graphics.printf('>>', 180, 210, VIRTUAL_WIDTH, 'left')
    elseif selection == 4 then
        love.graphics.printf('>>', 180, 220, VIRTUAL_WIDTH, 'left')
    end

end
