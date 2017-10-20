local TileMap = require('lib/TileMap')
local TilePlayer = require('lib/TilePlayer')

GAME_RUNNING = true
GAME_PAUSED = false

local GS = {}

function love.load()
  love.window.title = "48 Hour Game"
  GS.my_map = TileMap:new()
end

function love.keypressed(key)
  if not GAME_RUNNING then
    GAME_RUNNING = true
  elseif key == 'space' then
    GAME_PAUSED = not GAME_PAUSED
  end
end

function love.update(dt)
  if not GAME_RUNNING then 
    return 
  end
  if GAME_PAUSED then
    dt = 0
  end
end

function love.draw()
  love.graphics.print((GAME_PAUSED and "Pause" or "Unpaused"), 5,5)
  love.graphics.print(GS.my_map:_print(), 5, 25)
end

