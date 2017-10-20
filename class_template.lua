local MYCLASS = {
}
MYCLASS.__index = MYCLASS 

MYCLASS.new = function (init)
  local self = setmetatable({}, MYCLASS)

  return self
end

function MYCLASS:_print()
  local result = ""
  return result
end

return MYCLASS

