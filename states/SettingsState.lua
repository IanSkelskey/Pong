SettingsState = Class{__includes = BaseState}

function SettingsState:init()
    selection = 1
end

function SettingsState:update(dt)

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

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if selection == 1 then

        elseif selection == 2 then
          gStateMachine:change('customization')
        elseif selection == 3 then

        end
    end

    if love.keyboard.wasPressed('backspace') then
      gStateMachine:change('title')
    end
end

function SettingsState:render()
	-- UI messages
    love.graphics.setFont(scoreFont)
    love.graphics.printf('Settings', 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Choose a submenu!', 0, 10, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Audio', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Customization', 0, VIRTUAL_HEIGHT/2 + 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Controls', 0, VIRTUAL_HEIGHT/2 + 20, VIRTUAL_WIDTH, 'center')

    if selection == 1 then
        love.graphics.printf('>>', 160, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'left')
    elseif selection == 2 then
        love.graphics.printf('>>', 160, VIRTUAL_HEIGHT/2 + 10, VIRTUAL_WIDTH, 'left')
    elseif selection == 3 then
        love.graphics.printf('>>', 160, VIRTUAL_HEIGHT/2 + 20, VIRTUAL_WIDTH, 'left')
    end
end

function SettingsState:exit()

end
