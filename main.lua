push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'


-- all code related to to game state and state machine
require 'StateMachine'
require 'states/BaseState'
require 'states/ScoreState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/TitleScreenState'



WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


local background = love.graphics.newImage('images/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('images/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60


local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Fifty Bird')


    -- initializing our fonts
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)


    -- initializing sounds
    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static'),
        ['countdown'] = love.audio.newSource('sounds/countDown.wav', 'static'),
        ['countdownend'] = love.audio.newSource('sounds/countDownEnd.wav', 'static'),
        ['10point'] = love.audio.newSource('sounds/10point.wav', 'static')
    }

    -- kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initializing state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountdownState() end,
    }

    gStateMachine:change('title')



    -- math.randomseed(os.time())

    love.keyboard.keyspressed = {}
    love.mouse.buttonspressed = {}
end

function love.resize(w, h)
    push:resize(w, h)

end

function love.keypressed(key)
    love.keyboard.keyspressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonspressed[button] = true
end

function love.mouse.wasPressed(key)
    return love.mouse.buttonspressed[key]
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keyspressed[key] then
        return true
    else
        return false
    end

end

function love.update(dt)

    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT


    gStateMachine:update(dt)

    -- reset input table
    love.keyboard.keyspressed = {}
    love.mouse.buttonspressed = {}

end

function love.draw()
    push:start()

    -- draw the background at negative loopin point
    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)


    push:finish()

end
