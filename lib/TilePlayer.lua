local TilePlayer = {
}
TilePlayer.__index = TilePlayer 

TilePlayer.new = function (init)
  local self = setmetatable({}, TilePlayer)

  self.loc = { x = 3, y = 3 }
  self.identifier = "@"
  self.sprite = "player"

  return self
end

function TilePlayer:draw(x,y)
  love.graphics.push()
  love.graphics.draw(Assets.img.entity_sheet,Assets.sprites[self.sprite],0,0)
  love.graphics.pop()
end

function TilePlayer:_print()
  local result = ""
  return result
end

return TilePlayer

