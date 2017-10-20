local TilePlayer = {
}
TilePlayer.__index = TilePlayer 

TilePlayer.new = function (init)
  local self = setmetatable({}, TilePlayer)

  return self
end

function TilePlayer:_print()
  local result = ""
  return result
end

return TilePlayer

