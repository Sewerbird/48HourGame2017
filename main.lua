inspect = require('inspect')
GS = {} --Gamestate
Assets = {} --Assets
Scenes = {} --Scenes

local EventQueue = require('lib/EventQueue')
local TileMap = require('lib/TileMap')
local TileEntity = require('lib/TileEntity')
local SceneStack = require('lib/SceneStack')
local MapScene = require('lib/MapScene')
local BattleScene = require('lib/BattleScene')

function love.load()
  love.window.setMode(1280, 720) --set the window dimensions to 650 by 650
  love.window.setTitle("48 Hour Game")
  GS = {
    input = EventQueue:new()
  }
  Assets = {}
  Scenes = SceneStack:new() --UI Views

  GAME_RUNNING = true
  GAME_PAUSED = false
  GAME_VIEW_IS_BATTLE = false
  GAME_VIEW_IS_MAP = true
  GAME_VIEW_IS_DEATH = false

  --Asset Loading
  Assets.img = {}
  Assets.img.map_tileset = love.graphics.newImage('assets/48HourTileset.png')
  Assets.img.entity_sheet = love.graphics.newImage('assets/48HourEntitySheet.png')
  Assets.img.battlescene = {swamp = { bg = love.graphics.newImage('assets/BattleSceneSwamp.png')}}
  Assets.tileset = {}
  Assets.tileset.grass = love.graphics.newQuad(0,0,100,100,Assets.img.map_tileset:getDimensions())
  Assets.tileset.wall = love.graphics.newQuad(100,0,100,100,Assets.img.map_tileset:getDimensions())
  Assets.sprites = {}
  Assets.sprites.player = {
    front = love.graphics.newQuad(0,0,100,100,Assets.img.entity_sheet:getDimensions()),
    back = love.graphics.newQuad(0,100,100,100,Assets.img.entity_sheet:getDimensions()),
    w = 100
  }
  Assets.sprites.bear = {
    front = love.graphics.newQuad(200,0,300,200,Assets.img.entity_sheet:getDimensions()),
    w = 300
  }
  Assets.sprites.berry = {
    fallow = love.graphics.newQuad(500,0,100,100,Assets.img.entity_sheet:getDimensions()),
    ripe = love.graphics.newQuad(500,100,100,100,Assets.img.entity_sheet:getDimensions()),
    w = 100
  }
  Assets.sprites.merchant = {
    w = 100,
    front = love.graphics.newQuad(0,200,100,100,Assets.img.entity_sheet:getDimensions())
  }
  Assets.sprites.sword = {
    w = 100,
    front = love.graphics.newQuad(600,100,100,100,Assets.img.entity_sheet:getDimensions()) 
  }
  Assets.sprites.potion = {
    w = 100,
    front = love.graphics.newQuad(600,0,100,100,Assets.img.entity_sheet:getDimensions()) 
  }
  Assets.sprites.torch = {
    w = 100,
    front = love.graphics.newQuad(700,0,100,100,Assets.img.entity_sheet:getDimensions()) 
  }
  Assets.sprites.reticule = {
    w = 100,
    front = love.graphics.newQuad(700,100,100,100,Assets.img.entity_sheet:getDimensions()) 
  }
  
  Assets.ui = {}
  Assets.ui.battlescene_bg = love.graphics.newQuad(0,0,1280,720,Assets.img.battlescene.swamp.bg:getDimensions())
  
  --Load Gamestate
  GS.my_map = TileMap:new()
  GS.my_player = TileEntity:new()
  GS.my_player.inventory = {
    TileEntity:new({ name = "sword", orient = "front", sprite = "sword", damage = 30, action = "p_attack", consumable = false }),
    TileEntity:new({ name = "potion", orient = "front", sprite = "potion", heal = 50, action = "p_heal", consumable = true }),
    TileEntity:new({ name = "torch", orient = "front", sprite = "torch", fuel = 30, action = "p_scare", consumable = true })
  }
  GS.my_player.inventory.selected = 1
  print("INVENTORY is " .. inspect(GS.my_player.inventory))
  GS.my_badguy = TileEntity:new()
  GS.my_badguy.name = "Rabid Bear"
  GS.my_badguy.sprite = "bear"
  GS.my_badguy.facing = "left"
  GS.my_badguy.orient = "front"
  GS.my_badguy.max_health = 100
  GS.my_badguy.health = 100
  GS.my_badguy.sprite_height = 200
  GS.my_badguy.sprite_width = 300
  GS.my_map:add(GS.my_player,GS.my_player.loc)

  --Load UI
  Scenes:push(MapScene:new())
end

function love.keypressed(key, scancode)
  if not GAME_RUNNING then
    GAME_RUNNING = true
  elseif key == 'space' then
    GAME_PAUSED = not GAME_PAUSED
  end

  if GAME_VIEW_IS_BATTLE then
    if GS.input:isEmpty() then
      if key == 'a' then
        GS.input:addCommand("p_use_selected_item")
      elseif key == 'enter' then
        GS.input:addCommand("p_end_turn")
      elseif key == 'left' then
        GS.input:addCommand("p_rifle_inventory_left")
      elseif key == 'right' then
        GS.input:addCommand("p_rifle_inventory_right")
      end
    end
  end

  if GAME_VIEW_IS_MAP then
    if GS.input:isEmpty() then
      if key == 'up' then
        GS.input:addCommand("p_mv_up")
      elseif key == 'down' then
        GS.input:addCommand("p_mv_down")
      elseif key == 'left' then
        GS.input:addCommand("p_mv_left")
      elseif key == 'right' then
        GS.input:addCommand("p_mv_right")
      end
    end
  end

  if GAME_VIEW_IS_DEATH then
    GS.input:addCommand("GAME_reload")
  end

end


function love.update(dt)
  if not GAME_RUNNING then 
    return 
  end
  if GAME_PAUSED then
    dt = 0
  end

  GS.input:update(dt)
end

function love.draw()
  love.graphics.push()
  Scenes:draw()
  love.graphics.pop()
  --Screenspace
  love.graphics.print(GS.input:status_string(),5,5)
end

