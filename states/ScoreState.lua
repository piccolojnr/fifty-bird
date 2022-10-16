ScoreState = Class { __includes = BaseState }


function ScoreState:enter(params)
    self.score = params.score
    self.highScore = saveData.load('score').highScore
    local pos = self.highScore - self.score

    if pos < 0 then
        self.position = 0
        self.msg = "Congratulations! You Have the New High Score!!!!!!"
        self.medal = medal['first']
    elseif pos == 0 then
        self.position = 1
        self.msg = "Oooh No! You Almost beat the High Score :(!!!!"
        self.medal = medal['second']

    elseif pos == 1 then
        self.position = 2
        self.msg = "Nice!!!!! You were the second Highest"
        self.medal = medal['third']
    else
        self.position = 3
        self.msg = "Oof! You Lost! :("
    end

end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)

    love.graphics.printf(self.msg, 0, 44, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 120, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('High Score: ' .. tostring(self.highScore), 0, 155, VIRTUAL_WIDTH, 'center')


    -- render medals
    if self.position <= 2 then
        love.graphics.draw(self.medal, VIRTUAL_WIDTH / 2 - 32, 175)
    end



    love.graphics.printf('Press Enter to Play Again', 0, 240, VIRTUAL_WIDTH, 'center')



end
