local TileCell = require('src/TileCell')
local TileEntity = require('src/TileEntity')

local TileMap = {
}
TileMap.__index = TileMap 

TileMap.new = function (init)
  local self = setmetatable({}, TileMap)

  self.map_width = init.width or 40
  self.map_height = init.height or 40
  self.map = {}

  return self
end

function TileMap:add(obj, loc)
  obj.loc = loc
  table.insert(self.map[loc.y][loc.x].entities, obj)
end

function TileMap:moveCompassEntity(locA,dir)
  if (math.mod(locA.y,2) == 1) then
    if dir == "NW" then
      self:moveRelEntity(locA,-1,-1)
    elseif dir == "N" then
      self:moveRelEntity(locA,0,-2)
    elseif dir == "NE" then
      self:moveRelEntity(locA,0,-1)
    elseif dir == "E" then
      self:moveRelEntity(locA,1,0)
    elseif dir == "SE" then
      self:moveRelEntity(locA,0,1)
    elseif dir == "S" then
      self:moveRelEntity(locA,0,2)
    elseif dir == "SW" then
      self:moveRelEntity(locA,-1,1)
    elseif dir == "W" then
      self:moveRelEntity(locA,-1,0)
    end
  else
    if dir == "NW" then
      self:moveRelEntity(locA,0,-1)
    elseif dir == "N" then
      self:moveRelEntity(locA,0,-2)
    elseif dir == "NE" then
      self:moveRelEntity(locA,1,-1)
    elseif dir == "E" then
      self:moveRelEntity(locA,1,0)
    elseif dir == "SE" then
      self:moveRelEntity(locA,1,1)
    elseif dir == "S" then
      self:moveRelEntity(locA,0,2)
    elseif dir == "SW" then
      self:moveRelEntity(locA,0,1)
    elseif dir == "W" then
      self:moveRelEntity(locA,-1,0)
    end
  end

end

function TileMap:moveRelEntity(locA,dx,dy)
  return self:moveEntity(locA, { y = locA.y + dy, x = locA.x + dx })
end

function TileMap:moveEntity(locA,locB)
  local src_loc = self.map[locA.y][locA.x]
  local tgt_loc = self.map[locB.y][locB.x]
  print("SRC_LOC is " .. inspect(src_loc))
  print("TGT_LOC is " .. inspect(tgt_loc))
  if src_loc and tgt_loc and math.abs(src_loc.loc.z - tgt_loc.loc.z) <= 1 then
    if #tgt_loc.entities == 0 then
      local to_move = table.remove(self.map[locA.y][locA.x].entities,1)
      self:add(to_move, locB)
      return true
    else --Something is there and we bumped into it: interact
      GS.input:addCommand("p_interact",locB,0.1)
    end
  else
    return false
  end
end

function TileMap:draw()
  --Draw Terrain
  for i = 1, self.map_height do
    for j = 1, self.map_width do
      self.map[i][j]:draw()
      love.graphics.push()
      local cell = self.map[i][j]
      love.graphics.translate(cell.loc.x * cell.cell_width - cell.cell_width/2 + ((math.mod(cell.loc.y,2)==0) and 50 or 0), cell.loc.y * cell.cell_height/2 - 100 - (25 * cell.loc.z + 1))
      love.graphics.translate(cell.cell_width/2,0)
      for i = 1, #cell.entities do
        cell.entities[i]:draw()
      end
      love.graphics.pop()
    end
  end
  --Draw Entities
  love.graphics.push()
  for i = 1, self.map_height do
    for j = 1, self.map_width do
    end
  end
  love.graphics.pop()
end

return TileMap
