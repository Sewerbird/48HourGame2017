local SceneStack = {
}
SceneStack.__index = SceneStack 

SceneStack.new = function (init)
  local self = setmetatable({}, SceneStack)

  self.stack = {}
  
  return self
end

function SceneStack:current()
  return self.stack[#self.stack]
end

function SceneStack:clear()
  self.stack = {}
end

function SceneStack:push(scene)
  table.insert(self.stack,scene)
end

function SceneStack:pop()
  return table.remove(self.stack, #self.stack)
end

function SceneStack:draw()
  if #self.stack > 0 then
    self.stack[#self.stack]:draw()
  end
end

return SceneStack

