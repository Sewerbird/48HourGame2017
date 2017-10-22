local TileCell = require('lib/TileCell')
local TileEntity = require('lib/TileEntity')

local TileMap = {
}
TileMap.__index = TileMap 

TileMap.new = function (init)
  local self = setmetatable({}, TileMap)

  self.map_width = init.width or 40
  self.map_height = init.height or 20
  self.map = {}

  local merchant_placed = false
  for i = 1, self.map_height do
    local row = {}
    for j = 1, self.map_width do
      if i == 1 or i == self.map_height or j == 1 or j == self.map_width or  math.random() > 0.8 then
        table.insert(row,TileCell:new(j,i,'wall',false))
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
    table.insert(self.map, row)
  end

  return self
end

function TileMap:add(obj, loc)
  obj.loc = loc
  table.insert(self.map[loc.y][loc.x].entities, obj)
end

function TileMap:moveRelEntity(locA,dx,dy)
  return self:moveEntity(locA, { y = locA.y + dy, x = locA.x + dx })
end

function TileMap:moveEntity(locA,locB)
  local src_loc = self.map[locA.y][locA.x]
  local tgt_loc = self.map[locB.y][locB.x]
  if src_loc and tgt_loc and tgt_loc.passable then
    if #tgt_loc.entities == 0 then
      local to_move = table.remove(self.map[locA.y][locA.x].entities,1)
      self:add(to_move, locB)
      return true
    else --Something is there and we bumped into it: interact
      GS.input:addCommand("p_interact",locB)
    end
  else
    return false
  end
end

function TileMap:draw()
  --Draw Terrain
  for i = 1, self.map_height do
    for j = 1, self.map_width do
      self.map[i][j]:draw()
    end
  end
  --Draw Entities
  love.graphics.push()
  for i = 1, self.map_height do
    for j = 1, self.map_width do
      love.graphics.push()
      local cell = self.map[i][j]
      love.graphics.translate(cell.loc.x * 100 - cell.cell_width/2, cell.loc.y * 100 - cell.cell_width)
      love.graphics.translate(cell.cell_width/2,0)
      for i = 1, #cell.entities do
        cell.entities[i]:draw()
      end
      love.graphics.pop()
    end
  end
  love.graphics.pop()
end

return TileMap
