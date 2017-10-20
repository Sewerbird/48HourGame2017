inspect = require('inspect')
GS = {}
Assets = {}

local TileMap = require('lib/TileMap')
local TilePlayer = require('lib/TilePlayer')

GAME_RUNNING = true
GAME_PAUSED = false


function love.load()
  love.window.title = "48 Hour Game"
  GS.my_map = TileMap:new()
  GS.my_player = TilePlayer:new()

  Assets.img = {}
  Assets.img.map_tileset = love.graphics.newImage('assets/48HourTileset.png')
  Assets.img.entity_sheet = love.graphics.newImage('assets/48HourEntitySheet.png')
  Assets.tileset = {}
  Assets.tileset.grass = love.graphics.newQuad(0,0,100,100,Assets.img.map_tileset:getDimensions())
  Assets.sprites = {}
  Assets.sprites.player = love.graphics.newQuad(0,0,100,100,Assets.img.entity_sheet:getDimensions())
  --
  --Load
  GS.my_map:add(GS.my_player,GS.my_player.loc)
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
  GS.my_map:draw()
  love.graphics.print((GAME_PAUSED and "Pause" or "Unpaused"), 5,5)
end

