local TileCell = {
}
TileCell.__index = TileCell 

TileCell.new = function (x,y)
  local self = setmetatable({}, TileCell)
  self.loc = { x = x, y = y }
  self.entities = {}
  return self
end

function TileCell:identifier()
  if #self.entities > 0 then
    return self.entities[1].identifier
  end
  return "."
end

function TileCell:_print()
  local result = ""
  return result
end

return TileCell

