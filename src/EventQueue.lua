local BattleScene = require('src/BattleScene')
local DeathScene = require('src/DeathScene')
local MapScene = require('src/MapScene')

local EventQueue = {
}
EventQueue.__index = EventQueue 

EventQueue.new = function (init)
  local self = setmetatable({}, EventQueue)

  self.queue = {}

  return self
end

function EventQueue:status_string()

  local s = self.queue[1] and ("("..(math.floor(10 * self.queue[1].duration)/10)..") ") or "(0.0) "
  for i = 1, #self.queue do
    s = s .. self.queue[i].tag .. "\n <- "
  end
  return s
end

function EventQueue:update(dt)
  while #self.queue > 0 and dt > 0 do
    local cmd = self.queue[1]
    if not self.queue[1].processed then
      self.queue[1].processed = true
      print("Processing command " .. self.queue[1].tag .. " with arg " .. inspect(self.queue[1]))
      if self.queue[1].tag == 'GAME_pop_battle' and (Scenes:current().scene_type == 'GAME_VIEW_BATTLE') then
        GS.input:clear()
        Scenes:pop()
        break
      elseif self.queue[1].tag == 'GAME_push_battle' and (Scenes:current().scene_type == 'GAME_VIEW_MAP') then
        GS.input:clear()
        Scenes:push(BattleScene:new())
        break
      elseif self.queue[1].tag == 'GAME_start' then
        GS.input:clear()
        Scenes:push(MapScene:new())
        break
      elseif self.queue[1].tag == 'GAME_reload' then
        GS.input:clear()
        love.load()
        break
      elseif cmd.tag == 'GAME_lose' then
        GS.input:clear()
        Scenes:push(DeathScene:new())
        break
      else
        print("Sending command begin: " .. inspect(self.queue[1]))
        local success = Scenes:current():receiveCommandBegin(self.queue[1])
        if not success then
          table.remove(self.queue,1)
          break
        end
      end
    end
    if self.queue[1].duration > dt then
      --Action still durating
      Scenes:current():receiveCommandUpdate(self.queue[1], dt)
      self.queue[1].duration = self.queue[1].duration - dt
      dt = 0 
    else
      --Action can be removed
      dt = 0
      --dt = dt - self.queue[1].duration
      Scenes:current():receiveCommandFinish(self.queue[1])
      self.queue[1].duration = 0
      table.remove(self.queue,1)
    end
  end
  --self:clear()
end

function EventQueue:isEmpty()
  return #self.queue == 0
end

function EventQueue:clear()
  self.queue = {}
end

function EventQueue:addCommand(tag, arg, duration)
  print("Adding command " .. tag .. inspect(arg))
  local dur = duration or 0.9
  table.insert(self.queue,{tag = tag, arg = arg, duration = dur, original_duration = dur})
end

return EventQueue

