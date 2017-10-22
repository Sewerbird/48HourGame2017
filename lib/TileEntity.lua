local TileEntity = {
}
TileEntity.__index = TileEntity 

TileEntity.new = function (self, init)
  local self = setmetatable({}, TileEntity)

  --Defaults
  init = init or {}
  self.loc = { map = nil, x = 2, y = 2 }
  self.off = { x = 0, y = 0}
  self.idx = "player" 
  self.sprite = "player"
  self.sprite_height = 100
  self.sprite_width = 100
  self.facing = "right"
  self.orient = "front"
  self.name = "Mr. Lanchol"
  self.max_health = 150
  self.health = 150
  self.damage = 30
  self.alive = true

  for k,v in pairs(init) do
    print("Setting" .. k .. " to " .. inspect(v))
    self[k] = v
  end

  return self
end

function TileEntity:interact()
end

function TileEntity:draw()
  love.graphics.push()
  local fac = self.facing == "right" and -1 or 1
  local quad_x_c = Assets.sprites[self.sprite].w
  love.graphics.draw(Assets.img.entity_sheet,Assets.sprites[self.sprite][self.orient],self.off.x,self.off.y,0,fac,1,quad_x_c/2,0)
  love.graphics.pop()
end

return TileEntity

