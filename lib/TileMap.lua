local TileCell = require('lib/TileCell')

local TileMap = {
}
TileMap.__index = TileMap 

TileMap.new = function (init)
  local self = setmetatable({}, TileMap)

  self.map_width = init.width or 40
  self.map_height = init.height or 20
  self.map = {}

  for i = 1, self.map_height do
    local row = {}
    for j = 1, self.map_width do
      if i == 1 or i == self.map_height or j == 1 or j == self.map_width or  math.random() > 0.8 then
        table.insert(row,TileCell:new(j,i,'wall',false))
      else --grass
        table.insert(row,TileCell:new(j,i,'grass',true))
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
    local to_move = table.remove(self.map[locA.y][locA.x].entities,1)
    self:add(to_move, locB)
  else
    return false
  end
end

function TileMap:draw()
  for i = 1, self.map_height do
    for j = 1, self.map_width do
      self.map[i][j]:draw()
    end
  end
end

return TileMap
