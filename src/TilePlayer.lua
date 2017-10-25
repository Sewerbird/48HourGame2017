local TileEntity = {
}
TileEntity.__index = TileEntity 

TileEntity.new = function (init)
  local self = setmetatable({}, TileEntity)

  self.loc = { map = nil, x = 2, y = 2 }
  self.pos = { x = 0, y = 0}
  self.idx = "player" 
  self.sprite = "player"
  self.sprite_height = 100
  self.sprite_width = 100
  self.facing = "right"
  self.orient = "front"
  self.name = "Mr. Lanchol"
  self.max_health = 100
  self.health = 100
  self.damage = 30
  self.alive = true

  return self
end

function TileEntity:draw()
  love.graphics.push()
  local fac = self.facing == "right" and -1 or 1
  local quad_x_c = Assets.sprites[self.sprite].w
  love.graphics.draw(Assets.img.entity_sheet,Assets.sprites[self.sprite][self.orient],0,0,0,fac,1,quad_x_c/2,0)
  love.graphics.pop()
end

function TileEntity:interact()
end

return TileEntity

