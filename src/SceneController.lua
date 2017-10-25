local Stack = require('lib/Stack')

local SceneController = {
}

SceneController.__index = SceneController 

SceneController.new = function (init)
  local self = setmetatable({}, SceneController)

  self.stack = Stack:new()

  return self
end

function SceneController:keyEvent(key)
  self.stack:current():keyEvent(key)
end

function SceneController:current()
  return self.stack:current()
end

function SceneController:push(scene)
  self.stack:push(scene)
end

function SceneController:pop()
  return self.stack:pop()
end

function SceneController:draw()
  self.stack:peek():draw()
end

return SceneController

