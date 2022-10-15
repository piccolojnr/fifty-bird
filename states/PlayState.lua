PlayState = Class { __includes = BaseState }


PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24


function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0
    -- initialize our last recorded y value for a gap placement
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- update timer for pipe spawning
    self.timer = self.timer + dt

    -- spawn a new pipe pair every second and a half
    if self.timer > 2 then
        -- modify the lastY
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        -- add a new pair at the end of our screen at our new y
        table.insert(self.pipePairs, PipePair(y))

        -- reset timer
        self.timer = 0
    end

    -- for every pair of pipes
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left allthe way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
            end
        end


        -- update position of pair
        pair:update(dt)
    end

    -- update bird based on gravity and input
    self.bird:update(dt)

    -- simple collison between bird and all pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)


    self.bird:render()
end
