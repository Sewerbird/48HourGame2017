local MYCLASS = {
}
MYCLASS.__index = MYCLASS 

MYCLASS.new = function (init)
  local self = setmetatable({}, MYCLASS)

  return self
end

return MYCLASS

