local TitleScene = {
}
TitleScene.__index = TitleScene 

TitleScene.new = function (init)
  local self = setmetatable({}, TitleScene)

  self.scene_type = 'GAME_VIEW_TITLE'

  self.font = love.graphics.newFont(28)

  return self
end

function TitleScene:keyEvent(k)
  GS.input:addCommand("GAME_start")
end

function TitleScene:receiveCommandBegin(command)
end

function TitleScene:receiveCommandUpdate(command,dt)
end

function TitleScene:receiveCommandFinish(command)
end

function TitleScene:draw()
  love.graphics.setFont(self.font)
  love.graphics.printf("You enter a dark forest full of rabid bears..", 0, love.graphics.getHeight()/2,love.graphics.getWidth(),'center')
end

return TitleScene

