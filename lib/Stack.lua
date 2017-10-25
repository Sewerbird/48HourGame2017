local Stack = {
}
Stack.__index = Stack 

Stack.new = function (init)
  local self = setmetatable({}, Stack)

  self.stack = {}
  
  return self
end

function Stack:current()
  return self.stack[#self.stack]
end

function Stack:clear()
  self.stack = {}
end

function Stack:peek()
  if #self.stack then
    return self.stack[#self.stack]
  end
end

function Stack:push(e)
  table.insert(self.stack,e)
end

function Stack:pop()
  return table.remove(self.stack, #self.stack)
end

return Stack

