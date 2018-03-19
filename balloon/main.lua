-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--intialize the physics image
local physics = require( "physics" )
physics.start()

--holds value for half of the screen width and height.
halfW = display.contentWidth*0.5
halfH = display.contentHeight*0.5

--reading in an image file and displaying it on the screen
local bkg = display.newImage( "night_sky.png", halfW, halfH)

--set the score
score = 0
scoreText = display.newText(score, halfW, 10)

--if the balloon is touched the program will interact
local function balloonTouched(event)
  if( event.phase == "began" ) then
    Runtime:removeEventListener( "enterframe", event.self)
    event.target:removeSelf()
    score = score + 1
    scoreText.text = score
  end
end

local function bombTouched(event)
    if ( event.phase == "began" ) then
        Runtime:removeEventListener( "enterFrame", event.self )
        event.target:removeSelf()
        score = math.floor(score * 0.5)
        scoreText.text = score
    end
end

local function offscreen(self, event)
  if(self.y == nil) then
    return
  end
  if(self.y > display.contentHeight + 50) then
    Runtime:removeEventListener( "enterFrame", self )
    self:removeSelf()
  end
end

--adding new bomb or balloon
local function addNewBalloonOrBomb()
  local startX = math.random(display.contentWidth*0.1,display.contentWidth*0.9)
  if(math.random(1,5)==1) then
    -- BOMB!
    local bomb = display.newImage( "bomb.png", startX, -300)
    physics.addBody( bomb )
    bomb.enterFrame = offscreen
    Runtime:addEventListener( "enterFrame", bomb )
    bomb:addEventListener( "touch", bombTouched )
  else
    -- Balloon
    local balloon = display.newImage( "red_balloon.png", startX, -300)
    physics.addBody( balloon )
    balloon.enterFrame = offscreen
    Runtime:addEventListener( "enterFrame", balloon )
    balloon:addEventListener( "touch", balloonTouched )
  end
end

addNewBalloonOrBomb()
timer.performWithDelay( 500, addNewBalloonOrBomb, 0 )
