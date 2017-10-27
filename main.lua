inspect = require('lib/inspect')

GS = {} --Gamestate
Assets = {} --Assets 
Scenes = {} --UI

local EventQueue = require('src/EventQueue')
local SceneController = require('src/SceneController')
local TitleScene = require('src/TitleScene')

function love.load()
  require('src/Assets')(Assets)
  require('src/Loader')(GS)
  --Load UI
  love.window.setMode(1280, 720) --set the window dimensions to 650 by 650
  love.window.setTitle("48 Hour Game")
  Scenes = SceneController:new() --UI Views
  GAME_RUNNING = true
  GAME_PAUSED = false
  Scenes:push(TitleScene:new())
end

function love.keypressed(key, scancode)
  --Global Key Events
  if not GAME_RUNNING then
    GAME_RUNNING = true
  elseif key == 'space' then
    GAME_PAUSED = not GAME_PAUSED
  end
  --Contextual Key Events
  if GS.input:isEmpty() then
    Scenes:keyEvent(key)
  end
end

S = ""
function love.mousepressed(x,y)
  S = "clicked on " .. x .. " , " .. y
  print(s)
end


function love.update(dt)
  if not GAME_RUNNING then return end
  if GAME_PAUSED then dt = 0 end

  GS.input:update(dt)
end

function love.draw()
  love.graphics.push()
  Scenes:draw()
  love.graphics.pop()
  love.graphics.print(S,20,20)
end

