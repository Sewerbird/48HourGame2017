local MapScene = {
}
MapScene.__index = MapScene 

MapScene.new = function ()
  local self = setmetatable({}, MapScene)

  self.scene_type = 'GAME_VIEW_MAP'

  return self
end

function MapScene:keyEvent(key)
  if key == 'up' then
    GS.input:addCommand("p_mv_up",nil,0.1)
  elseif key == 'down' then
    GS.input:addCommand("p_mv_down",nil,0.1)
  elseif key == 'left' then
    GS.input:addCommand("p_mv_left",nil,0.1)
  elseif key == 'right' then
    GS.input:addCommand("p_mv_right",nil,0.1)
  elseif key == 't' then
    GS.input:addCommand("p_mv_N",nil,0.0)
  elseif key == 'b' then
    GS.input:addCommand("p_mv_S",nil,0.05)
  elseif key == 'f' then
    GS.input:addCommand("p_mv_W",nil,0.2)
  elseif key == 'h' then
    GS.input:addCommand("p_mv_E",nil,0.2)
  elseif key == 'r' then
    GS.input:addCommand("p_mv_NW",nil,0.2)
  elseif key == 'y' then
    GS.input:addCommand("p_mv_NE",nil,0.2)
  elseif key == 'n' then
    GS.input:addCommand("p_mv_SE",nil,0.2)
  elseif key == 'v' then
    GS.input:addCommand("p_mv_SW",nil,0.2)
  end
end

function MapScene:receiveCommandBegin(command)
  local cmd = command.tag
  local arg = command.arg
  if cmd == nil then return end
  if cmd == 'p_mv_up' then
    local can = GS.my_map:moveCompassEntity(GS.my_player.loc,"NE")
    if not can then return false end
    GS.my_player.orient = "back"
  elseif cmd == 'p_mv_down' then
    local can = GS.my_map:moveCompassEntity(GS.my_player.loc,"SW")
    if not can then return false end
    GS.my_player.orient = "front"
  elseif cmd == 'p_mv_left' then
    local can = GS.my_map:moveCompassEntity(GS.my_player.loc,"NW")
    if not can then return false end
    GS.my_player.facing = "left"
  elseif cmd == 'p_mv_right' then
    local can = GS.my_map:moveCompassEntity(GS.my_player.loc,"SE")
    if not can then return false end
    GS.my_player.facing = "right"
  elseif cmd == 'p_mv_N' then
    GS.my_map:moveCompassEntity(GS.my_player.loc,"N")
  elseif cmd == 'p_mv_S' then
    GS.my_map:moveCompassEntity(GS.my_player.loc,"S")
  elseif cmd == 'p_mv_E' then
    GS.my_map:moveCompassEntity(GS.my_player.loc,"E")
  elseif cmd == 'p_mv_W' then
    GS.my_map:moveCompassEntity(GS.my_player.loc,"W")
  elseif cmd == 'p_mv_NW' then
    GS.my_map:moveCompassEntity(GS.my_player.loc,"NW")
  elseif cmd == 'p_mv_SW' then
    GS.my_map:moveCompassEntity(GS.my_player.loc,"SW")
  elseif cmd == 'p_mv_NE' then
    GS.my_map:moveCompassEntity(GS.my_player.loc,"NE")
  elseif cmd == 'p_mv_SE' then
    GS.my_map:moveCompassEntity(GS.my_player.loc,"SE")
  elseif cmd == 'p_interact' then
    GS.my_map.map[arg.y][arg.x].entities[1]:interact()
  end
  return true
end

function MapScene:receiveCommandUpdate(command,dt)
  local cmd = command.tag
  if cmd == 'p_mv_up' then
    GS.my_player.off.y = 50 * (command.duration - dt)/command.original_duration
  elseif cmd == 'p_mv_down' then
    GS.my_player.off.y = -50 * (command.duration - dt)/command.original_duration
  elseif cmd == 'p_mv_left' then
    GS.my_player.off.x = 100 * (command.duration - dt)/command.original_duration
  elseif cmd == 'p_mv_right' then
    GS.my_player.off.x = -100 * (command.duration - dt)/command.original_duration
  end
end

function MapScene:receiveCommandFinish(command)
  local cmd = command.tag
  if cmd == 'p_mv_up' then
    if math.random() > 0.95 then self:triggerBattle() end
    GS.my_player.off.y = 0
    GS.my_player.off.x = 0
  elseif cmd == 'p_mv_down' then
    if math.random() > 0.95 then self:triggerBattle() end
    GS.my_player.off.y = 0
    GS.my_player.off.x = 0
  elseif cmd == 'p_mv_left' then
    if math.random() > 0.95 then self:triggerBattle() end
    GS.my_player.off.y = 0
    GS.my_player.off.x = 0
  elseif cmd == 'p_mv_right' then
    if math.random() > 0.95 then self:triggerBattle() end
    GS.my_player.off.y = 0
    GS.my_player.off.x = 0
  end
end

function MapScene:triggerBattle()
  GS.my_badguy.alive = true
  GS.my_badguy.health = GS.my_badguy.max_health
  GS.input:addCommand("GAME_push_battle")
end

function MapScene:screenToTile(x,y)
end

function MapScene:draw()
  --Worldspace
  local translate_x = GS.my_player.loc.x * 100 + GS.my_player.off.x
  local translate_y = GS.my_player.loc.y * 25 + GS.my_player.off.y
  --love.graphics.translate(love.graphics:getWidth()/2-translate_x, love.graphics:getHeight()/2-translate_y)
  GS.my_map:draw()
end

return MapScene

