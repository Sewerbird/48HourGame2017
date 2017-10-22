local TileCell = {
}
TileCell.__index = TileCell 

TileCell.new = function (self,x,y,terrain,passable)
  local self = setmetatable({}, TileCell)
  self.loc = { x = x, y = y }
  self.entities = {}
  self.terrain = terrain or "grass"
  self.cell_width = 100
  self.passable = passable ~= nil and passable or false
  return self
end

function TileCell:draw()
  love.graphics.push()
  love.graphics.translate(self.loc.x * 100 - self.cell_width/2, self.loc.y * 100 - self.cell_width)
  love.graphics.draw(Assets.img.map_tileset,Assets.tileset[self.terrain],0,0)
  love.graphics.pop()
end

return TileCell

