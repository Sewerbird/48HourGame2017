local TilePlayer = {
}
TilePlayer.__index = TilePlayer 

TilePlayer.new = function (init)
  local self = setmetatable({}, TilePlayer)

  self.loc = { x = 3, y = 3 }
  self.identifier = "@"

  return self
end

function TilePlayer:_print()
  local result = ""
  return result
end

return TilePlayer

