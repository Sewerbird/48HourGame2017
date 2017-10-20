local TileCell = require('lib/TileCell')

local TileMap = {
}
TileMap.__index = TileMap 

TileMap.new = function (init)
  local self = setmetatable({}, TileMap)

  local map_width = init.width or 10
  local map_height = init.height or 10

  self.map = {}

  for i = 1, map_height do
    local row = {}
    for j = 1, map_width do
      table.insert(row,TileCell:new(j,i))
    end
    table.insert(self.map, row)
  end

  return self
end

function TileMap:add(obj, loc)
  obj.loc = self.loc
  table.insert(self.map[loc.y][loc.x].entities, obj)
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
