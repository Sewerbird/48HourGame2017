local EventQueue = require('src/EventQueue')
local TileMap = require('src/TileMap')
local TileCell = require('src/TileCell')
local TileEntity = require('src/TileEntity')

local Loader = function(GS)
  --Setup Gamestate EventBus
  GS.input = EventQueue:new()
  --Load Gamestate
  GS.my_map = TileMap:new()
  local merchant_placed = false
  for i = 1, GS.my_map.map_height do
    local row = {}
    for j = 1, GS.my_map.map_width do
      if false and (i == 1 or i == GS.my_map.map_height or j == 1 or j == GS.my_map.map_width or  math.random() > 0.8) then
        --table.insert(row,TileCell:new(j,i,'wall',false))
      else --grass
        local grass = TileCell:new(j,i,'grass',true)
        if math.random() > 0.99 and not merchant_placed then
          merchant_placed = true
          local merchant = TileEntity:new()
          merchant.interact = function()
          end
          merchant.loc = {x = j, y = i}
          merchant.sprite = "merchant"
          merchant.orient = "front"
          merchant.idx = "Merchant"
          merchant.damage = 10
          merchant.health = 100
          merchant.name = "Bethany"
          table.insert(grass.entities, merchant)
        elseif math.random() > 0.95 then --do a bush
          local bush = TileEntity:new()
          bush.interact = function(self)
            if self.ripe then
              table.insert(GS.my_player.inventory, TileEntity:new({ name = "potion", orient = "front", sprite = "potion", heal = 90, action = "p_heal", consumable = true}))
              self.orient = "fallow"
              self.ripe = false
            end
          end
          bush.loc = {x = j, y = i}
          bush.sprite = "berry"
          bush.orient = "ripe"
          bush.idx = "Berry"
          bush.damage = 0
          bush.health = 100
          bush.name = "Berry Bush"
          bush.ripe = true
          print("Adding a bush" .. inspect(bush))
          table.insert(grass.entities, bush)
        end
        table.insert(row, grass)
      end
    end
    table.insert(GS.my_map.map, row)
  end

  GS.my_player = TileEntity:new()
  GS.my_player.inventory = {
    TileEntity:new({ name = "sword", orient = "front", sprite = "sword", damage = 30, action = "p_attack", consumable = false }),
    TileEntity:new({ name = "potion", orient = "front", sprite = "potion", heal = 50, action = "p_heal", consumable = true }),
    TileEntity:new({ name = "torch", orient = "front", sprite = "torch", fuel = 30, action = "p_scare", consumable = true })
  }
  GS.my_player.inventory.selected = 1
  GS.my_badguy = TileEntity:new()
  GS.my_badguy.name = "Rabid Bear"
  GS.my_badguy.sprite = "bear"
  GS.my_badguy.facing = "left"
  GS.my_badguy.orient = "front"
  GS.my_badguy.max_health = 10
  GS.my_badguy.health = 10
  GS.my_badguy.sprite_height = 200
  GS.my_badguy.sprite_width = 300
  GS.my_map:add(GS.my_player,GS.my_player.loc)
end

return Loader
