local TileEntity = {
}
TileEntity.__index = TileEntity 

TileEntity.new = function (self, init)
  local self = setmetatable({}, TileEntity)

  --Defaults
  init = init or {}
  self.loc = { map = nil, x = 8, y = 8, z = 0 }
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
  local quad_y_c = Assets.sprites[self.sprite].h
  love.graphics.draw(Assets.img.entity_sheet,Assets.sprites[self.sprite][self.orient],self.off.x,self.off.y,0,fac,1,quad_x_c/2,0)
  if true then 
    love.graphics.setColor(0,255,255)
    if self.debug_color then love.graphics.setColor(255,0,0) end
    love.graphics.rectangle('line',-quad_x_c/2,0,100,100) 
    love.graphics.setColor(200,0,0)
    love.graphics.circle('fill',-quad_x_c/2,quad_y_c/2,10,10)
    love.graphics.setColor(255,255,255)
  end
  love.graphics.pop()
end

return TileEntity

