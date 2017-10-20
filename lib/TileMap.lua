local TileCell = require('lib/TileCell')

local TileMap = {
}
TileMap.__index = TileMap 

TileMap.new = function (init)
  local self = setmetatable({}, TileMap)

  self.map_width = init.width or 10
  self.map_height = init.height or 10
  self.map = {}

  for i = 1, self.map_height do
    local row = {}
    for j = 1, self.map_width do
      if math.random() > 0.8 then
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
  local tgt_loc = self.map[locA.y+dy] and self.map[locA.y+dy][locA.x+dx]
  if tgt_loc and tgt_loc.passable then
    local to_move = table.remove(self.map[locA.y][locA.x].entities,1)
    self:add(to_move,{ y = locA.y + dy, x = locA.x + dx})
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

function TileMap:_print()
  local result = ""
  for i = 1, #self.map do
    local row = self.map[i]
    for j = 1, #row do
      local cell = row[j]
      result = result .. cell:identifier()
    end
    result = result .. "\n"
  end
  return result
end

return TileMap
