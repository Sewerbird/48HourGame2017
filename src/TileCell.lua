local TileCell = {
}
TileCell.__index = TileCell 

TileCell.new = function (self,x,y,terrain,passable,z)
  local self = setmetatable({}, TileCell)
  self.loc = { x = x, y = y, z = z or 0}
  self.entities = {}
  self.terrain = terrain or "grass"
  self.cell_width = 100
  self.cell_height = 50
  self.passable = passable ~= nil and passable or false
  return self
end

function TileCell:draw()
  love.graphics.push()
  --TODO: Tile cells have 50px of 'height'
  love.graphics.translate(self.loc.x * self.cell_width - self.cell_width/2 + ((math.mod(self.loc.y,2)==0) and 50 or 0), self.loc.y * self.cell_height/2 - 50 - (25*self.loc.z))
  if true then 
    love.graphics.setColor(255,255,255)
    if self.debug_color then love.graphics.setColor(255,0,0) end
    love.graphics.rectangle('line',0,0,100,50) 
    love.graphics.setColor(100,0,0)
    love.graphics.circle('fill',0,0,10,10)
    love.graphics.setColor(255,255,255)
    local px = self.loc.x * self.cell_width - self.cell_width/2 + ((math.mod(self.loc.y,2)==0) and 50 or 0)
    local py = self.loc.y * self.cell_height/2 - 50 - (25*self.loc.z)
    love.graphics.print(px .. "," .. py, 0,0)
  end
  love.graphics.draw(Assets.img.map_tileset,Assets.tileset[self.terrain],0,0)
  love.graphics.pop()
end

return TileCell

