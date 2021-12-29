--[[
    GD50 2018
    Pong Remake

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.
]]

Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.shape = 'square'

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0
    self.color = 'white'
end

--[[
    Expects a paddle as an argument and returns true or false, depending
    on whether their rectangles overlap.
]]
function Ball:collides(paddle)

    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end
    --change color of ball to match paddle it collides with.
    self.color = paddle.color
    -- if the above aren't true, they're overlapping
    return true
end

--[[
    Places the ball in the middle of the screen, with no movement.
]]
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
    self.color = 'white'
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    if self.color == 'white' then

    elseif self.color == 'red' then
        love.graphics.setColor(.67, .20, .20, 1)
    elseif self.color == 'green' then
        love.graphics.setColor(.22, .58, .43, 1)
    elseif self.color == 'blue' then
        love.graphics.setColor(.35, .43, .88, 1)
    end
    if(self.shape == 'square') then
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    elseif(self.shape == 'circle') then
        love.graphics.circle('fill', self.x, self.y, self.width/2, 6)
    end
    love.graphics.setColor(1, 1, 1, 1)
end
