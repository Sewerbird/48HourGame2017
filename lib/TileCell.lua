local TileCell = {
}
TileCell.__index = TileCell 

TileCell.new = function (self,x,y,terrain,passable)
  local self = setmetatable({}, TileCell)
  self.loc = { x = x, y = y }
  self.entities = {}
  self.identifier = "."
  self.terrain = terrain or "grass"
  self.passable = passable ~= nil and passable or false
  return self
end

function TileCell:identifier()
  if #self.entities > 0 then
    return self.entities[1].identifier
  end
  return "."
end

function TileCell:draw()
  love.graphics.push()
  love.graphics.translate(self.loc.x * 100, self.loc.y * 100)
  --Draw Terrain
  love.graphics.draw(Assets.img.map_tileset,Assets.tileset[self.terrain],0,0)
  --Draw Entities
  for i = 1, #self.entities do
    self.entities[i]:draw(0,0)
  end
  love.graphics.pop()
end

function TileCell:_print()
  local result = ""
  return result
end

return TileCell

