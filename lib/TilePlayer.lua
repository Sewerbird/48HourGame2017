local TilePlayer = {
}
TilePlayer.__index = TilePlayer 

TilePlayer.new = function (init)
  local self = setmetatable({}, TilePlayer)

  self.loc = { map = nil, x = 3, y = 3 }
  self.idx = "player" 
  self.sprite = "player"

  return self
end

function TilePlayer:draw(x,y)
  love.graphics.push()
  love.graphics.draw(Assets.img.entity_sheet,Assets.sprites[self.sprite],0,0)
  love.graphics.pop()
end

return TilePlayer

