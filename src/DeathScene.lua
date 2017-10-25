local DeathScene = {
}
DeathScene.__index = DeathScene 

DeathScene.new = function (init)
  local self = setmetatable({}, DeathScene)

  self.scene_type = 'GAME_VIEW_DEATH'
  
  return self
end

function DeathScene:keyEvent(k)
  GS.input:addCommand("GAME_reload")
end

function DeathScene:receiveCommandBegin(command)
end

function DeathScene:receiveCommandUpdate(command,dt)
end

function DeathScene:receiveCommandFinish(command)
end

function DeathScene:draw()
  love.graphics.printf("You have died. Perhaps another will try the Dark Forest...", 0, love.graphics.getHeight()/2,love.graphics.getWidth(),'center')
end

return DeathScene

