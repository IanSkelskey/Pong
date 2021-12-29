--[[
    GD50 2018
    Pong Remake

    -- Main Program --

        Author: Colton Ogden
        cogden@cs50.harvard.edu

    -- Single/Multiplayer Functionality & AI --
        05/03/2020
        Author: Ian Skelskey
        ianskelskey@gmail.com

    Originally programmed by Atari in 1972. Features two
    paddles, controlled by players, with the goal of getting
    the ball past your opponent's edge. First to 10 points wins.

    This version is built to more closely resemble the NES than
    the original Pong machines or the Atari 2600 in terms of
    resolution, though in widescreen (16:9) so it looks nicer on
    modern systems.
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- our Paddle class, which stores position and dimensions for each Paddle
-- and the logic for rendering them
require 'Paddle'

-- our Ball class, which isn't much different than a Paddle structure-wise
-- but which will mechanically function very differently
require 'Ball'

-- A statemachine class to store multiple game stats and transition between them
require 'StateMachine'

require 'conf'

-- all states our StateMachine can transition between
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/DifficultySelectState'
require 'states/ServeState'
require 'states/TrainingServeState'
require 'states/TrainingState'
require 'states/ControlsState'
require 'states/SettingsState'
require 'states/CustomizationState'
require 'states/DoneState'


-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- paddle movement speed
PADDLE_SPEED = 200

MASTER_VOLUME = 0

-- initialize our player paddles; make them global so that they can be
-- detected by other functions and modules
player1 = Paddle(10, 30, 5, 20)
player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

--initialize a wall for training Mode
wall = Paddle(0, 0, 5, VIRTUAL_HEIGHT)

-- place a ball in the middle of the screen
ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

-- initialize score variables
player1Score = 0
player2Score = 0

-- a variable to store # of players
singlePlayer = true

-- a variable to store the difficulty for single player games
difficulty = 'easy'

-- either going to be 1 or 2; whomever is scored on gets to serve the
-- following turn
servingPlayer = 1

-- player who won the game; not set to a proper value until we reach
-- that state in the game
winningPlayer = 0

--[[
    Called just once at the beginning of the game; used to set up
    game objects, variables, etc. and prepare the game world.
]]
function love.load()
    -- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- set the title of our application window
    love.window.setTitle('Pong')

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['score2'] = love.audio.newSource('sounds/score2.wav', 'static')
    }

    hitSounds = {
        ['e'] = love.audio.newSource('sounds/paddle/boop-e.wav', 'static'),
        ['f#'] = love.audio.newSource('sounds/paddle/boop-f#.wav', 'static'),
        ['g#'] = love.audio.newSource('sounds/paddle/boop-g#.wav', 'static'),
        ['b'] = love.audio.newSource('sounds/paddle/boop-b.wav', 'static'),
        ['c#'] = love.audio.newSource('sounds/paddle/boop-c#.wav', 'static'),
    }

    music = {
        ['intro-chord'] = love.audio.newSource('music/intro-chord.wav', 'static'),
        ['bass-loop'] = love.audio.newSource('music/bass vibes.wav', 'static')
	}

    sounds['paddle_hit']:setVolume(MASTER_VOLUME)
    sounds['select']:setVolume(MASTER_VOLUME)
    sounds['score']:setVolume(MASTER_VOLUME)
    sounds['wall_hit']:setVolume(MASTER_VOLUME)
    sounds['score2']:setVolume(MASTER_VOLUME)
    hitSounds['e']:setVolume(MASTER_VOLUME)
    hitSounds['f#']:setVolume(MASTER_VOLUME)
    hitSounds['g#']:setVolume(MASTER_VOLUME)
    hitSounds['b']:setVolume(MASTER_VOLUME)
    hitSounds['c#']:setVolume(MASTER_VOLUME)
    music['intro-chord']:setVolume(MASTER_VOLUME)
    music['bass-loop']:setVolume(MASTER_VOLUME)

    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })

    -- the state of our game; can be any of the following:
    -- 1. 'start' (the beginning of the game, before first serve)
    -- 2. 'serve' (waiting on a key press to serve the ball)
    -- 3. 'play' (the ball is in play, bouncing between paddles)
    -- 4. 'done' (the game is over, with a victor, ready for restart)
        -- initialize state machine with all state-returning functions

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['difficulty'] = function() return DifficultySelectState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function() return ServeState() end,
        ['training-serve'] = function() return TrainingServeState() end,
        ['training'] = function() return TrainingState() end,
        ['done'] = function() return DoneState() end,
        ['controls'] = function() return ControlsState() end,
        ['settings'] = function() return SettingsState() end,
        ['customization'] = function() return CustomizationState() end
    }
    gStateMachine:change('title')

    -- initialize input table
    love.keyboard.keysPressed = {}

    music['intro-chord']:setLooping(false)
    music['intro-chord']:seek(0.01)
    music['intro-chord']:play()

end

--[[
    Called whenever we change the dimensions of our window, as by dragging
    out its bottom corner, for example. In this case, we only need to worry
    about calling out to `push` to handle the resizing. Takes in a `w` and
    `h` variable representing width and height, respectively.
]]
function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end

end



--[[
    Custom function to extend LÖVE's input handling; returns whether a given
    key was set to true in our input table this frame.
]]
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end


--[[
    Called every frame, passing in `dt` since the last frame. `dt`
    is short for `deltaTime` and is measured in seconds. Multiplying
    this by any changes we wish to make in our game will allow our
    game to perform consistently across all hardware; otherwise, any
    changes we make will be applied as fast as possible and will vary
    across system hardware.
]]
function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}

end

--[[
    Called each frame after update; is responsible simply for
    drawing all of our game objects and more to the screen.
]]
function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:start()

    love.graphics.clear(40/255, 45/255, 52/255, 1) --rgb values only from 0 to 1

    gStateMachine:render()

    -- show the score before ball is rendered so it can move over the text
    displayScore()


    if debugMode == true then
        -- display FPS for debugging; simply comment out to remove
        displayFPS()
    end

    -- end our drawing to push
    push:finish()
end

--[[
    Simple function for rendering the scores.
]]
function displayScore()
    if gStateMachine:currentState() == 'play' or gStateMachine:currentState() == 'training'
            or gStateMachine:currentState() == 'serve' or gStateMachine:currentState() == 'training-serve' then
        isPlayState = true
    end

    -- score display
    love.graphics.setFont(scoreFont)

    -- try printing currentState to console to verify output
    --print(gStateMachine:currentState())
    if isPlayState then
        if gStateMachine:currentState() ~= 'training-serve' and gStateMachine:currentState() ~= 'training' then
            love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
                VIRTUAL_HEIGHT / 3)
            love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
                VIRTUAL_HEIGHT / 3)
        else
            love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 - 10,
                VIRTUAL_HEIGHT / 3)
        end
    end
end

--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(255, 255, 255, 255)
end
