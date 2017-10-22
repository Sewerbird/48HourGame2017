local MapScene = {
}
MapScene.__index = MapScene 

MapScene.new = function ()
  local self = setmetatable({}, MapScene)

  return self
end

function MapScene:receiveCommandBegin(command)
  local cmd = command.tag
  local arg = command.arg
  if cmd == nil then return end
  if cmd == 'p_mv_up' then
    local can = GS.my_map:moveRelEntity(GS.my_player.loc,0,-1)
    if not can then return false end
    GS.my_player.orient = "back"
  elseif cmd == 'p_mv_down' then
    local can = GS.my_map:moveRelEntity(GS.my_player.loc,0,1)
    if not can then return false end
    GS.my_player.orient = "front"
  elseif cmd == 'p_mv_left' then
    local can = GS.my_map:moveRelEntity(GS.my_player.loc,-1,0)
    if not can then return false end
    GS.my_player.facing = "left"
  elseif cmd == 'p_mv_right' then
    local can = GS.my_map:moveRelEntity(GS.my_player.loc,1,0)
    if not can then return false end
    GS.my_player.facing = "right"
  elseif cmd == 'p_interact' then
    GS.my_map.map[arg.y][arg.x].entities[1]:interact()
  end
  return true
end

function MapScene:receiveCommandUpdate(command,dt)
  local cmd = command.tag
  if cmd == 'p_mv_up' then
    GS.my_player.off.y = 100 * (command.duration - dt)/command.original_duration
  elseif cmd == 'p_mv_down' then
    GS.my_player.off.y = -100 * (command.duration - dt)/command.original_duration
  elseif cmd == 'p_mv_left' then
    GS.my_player.off.x = 100 * (command.duration - dt)/command.original_duration
  elseif cmd == 'p_mv_right' then
    GS.my_player.off.x = -100 * (command.duration - dt)/command.original_duration
  end
end

function MapScene:receiveCommandFinish(command)
  local cmd = command.tag
  if cmd == 'p_mv_up' then
    if math.random() > 0.9 then self:triggerBattle() end
    GS.my_player.off.y = 0
    GS.my_player.off.x = 0
  elseif cmd == 'p_mv_down' then
    if math.random() > 0.9 then self:triggerBattle() end
    GS.my_player.off.y = 0
    GS.my_player.off.x = 0
  elseif cmd == 'p_mv_left' then
    if math.random() > 0.9 then self:triggerBattle() end
    GS.my_player.off.y = 0
    GS.my_player.off.x = 0
  elseif cmd == 'p_mv_right' then
    if math.random() > 0.9 then self:triggerBattle() end
    GS.my_player.off.y = 0
    GS.my_player.off.x = 0
  end
end

function MapScene:triggerBattle()
  GS.my_badguy.alive = true
  GS.my_badguy.health = GS.my_badguy.max_health
  GS.input:addCommand("GAME_push_battle")
end

function MapScene:draw()
  --Worldspace
  local translate_x = GS.my_player.loc.x * 100 + GS.my_player.off.x
  local translate_y = GS.my_player.loc.y * 100 + GS.my_player.off.y
  love.graphics.translate(love.graphics:getWidth()/2-translate_x, love.graphics:getHeight()/2-translate_y)
  GS.my_map:draw()
end

return MapScene

