inspect = require('inspect')
GS = {}
Assets = {}

local TileMap = require('lib/TileMap')
local TilePlayer = require('lib/TilePlayer')

GAME_RUNNING = true
GAME_PAUSED = false


function love.load()
  love.window.setMode(650, 650) --set the window dimensions to 650 by 650
  love.window.setTitle = "48 Hour Game"
  GS.input = {} --input queue

  GS.my_map = TileMap:new()
  GS.my_player = TilePlayer:new()

  Assets.img = {}
  Assets.img.map_tileset = love.graphics.newImage('assets/48HourTileset.png')
  Assets.img.entity_sheet = love.graphics.newImage('assets/48HourEntitySheet.png')
  Assets.tileset = {}
  Assets.tileset.grass = love.graphics.newQuad(0,0,100,100,Assets.img.map_tileset:getDimensions())
  Assets.tileset.wall = love.graphics.newQuad(100,0,100,100,Assets.img.map_tileset:getDimensions())
  Assets.sprites = {}
  Assets.sprites.player = love.graphics.newQuad(0,0,100,100,Assets.img.entity_sheet:getDimensions())
  --
  --Load
  GS.my_map:add(GS.my_player,GS.my_player.loc)
end

function love.keypressed(key, scancode)
  if not GAME_RUNNING then
    GAME_RUNNING = true
  elseif key == 'space' then
    GAME_PAUSED = not GAME_PAUSED
  end

  if key == 'up' then
    table.insert(GS.input,"p_mv_up")
  elseif key == 'down' then
    table.insert(GS.input,"p_mv_down")
  elseif key == 'left' then
    table.insert(GS.input,"p_mv_left")
  elseif key == 'right' then
    table.insert(GS.input,"p_mv_right")
  end
end

function love.update(dt)
  if not GAME_RUNNING then 
    return 
  end
  if GAME_PAUSED then
    dt = 0
  end

  if #GS.input then
    for i = 1, #GS.input do
      local cmd = GS.input[i]
      if cmd == 'p_mv_up' then
        GS.my_map:moveRelEntity(GS.my_player.loc,0,-1)
      elseif cmd == 'p_mv_down' then
        GS.my_map:moveRelEntity(GS.my_player.loc,0,1)
      elseif cmd == 'p_mv_left' then
        GS.my_map:moveRelEntity(GS.my_player.loc,-1,0)
      elseif cmd == 'p_mv_right' then
        GS.my_map:moveRelEntity(GS.my_player.loc,1,0)
      end
    end
    GS.input = {}
  end
end

function love.draw()
  love.graphics.push()
  --Worldspace
  love.graphics.translate(GS.my_player.loc.x * -100 + love.graphics:getWidth()/2, GS.my_player.loc.y * -100 + love.graphics:getHeight()/2)
  GS.my_map:draw()
  love.graphics.pop()
  --Screenspace
  love.graphics.print((GAME_PAUSED and "Pause" or "Unpaused"), 5,5)
end

