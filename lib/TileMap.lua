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
      table.insert(row,0)
    end
    table.insert(self.map, row)
  end

  return self
end

function TileMap:_print()
  local result = ""
  for i = 1, #self.map do
    local row = self.map[i]
    for j = 1, #row do
      result = result .. row[j]
    end
    result = result .. "\n"
  end
  return result
end

return TileMap
