local BattleScene = {
}
BattleScene.__index = BattleScene 

BattleScene.new = function ()
  local self = setmetatable({}, BattleScene)

  self.ground_level = 400
  self.ui_level = 450
  self.ui_left = 90
  self.ui_right = 900
  self.font = love.graphics.newFont(28)

  self.allies = {}
  self.enemies = {}
  
  
  self.IS_PLAYER_TURN = true

  table.insert(self.allies,GS.my_player)
  table.insert(self.enemies,GS.my_badguy)

  self.target_guy = self.enemies[#self.enemies]
  self.selected = self.allies[#self.allies]
  self.selected_item = nil

  return self
end

function BattleScene:receiveCommandBegin(command)
  local cmd = command.tag
  local arg = command.arg
  if self.IS_PLAYER_TURN then
    if cmd == 'p_run_away' then
      self:escapeBattle()
    elseif cmd == 'p_attack' then
      self:attackTargetWithSelected(self.allies[1],self.enemies[1],arg)
    elseif cmd == 'p_heal' then
      print("HEALING")
      self:healTargetWithSelected(self.allies[1],self.allies[1],arg)
    elseif cmd == 'p_scare' then
      self:scareTargetWithSelected(self.allies[1],self.enemies[1],args)
    elseif cmd == 'p_end_turn' then
      self:endTurn()
    elseif cmd == 'p_rifle_inventory_right' then
      self.selected.inventory.selected = self.selected.inventory.selected == #self.selected.inventory and 1 or self.selected.inventory.selected + 1
    elseif cmd == 'p_rifle_inventory_left' then
      self.selected.inventory.selected = self.selected.inventory.selected == 1 and #self.selected.inventory or self.selected.inventory.selected - 1
    elseif cmd == 'p_use_selected_item' then
      GS.input:addCommand(self.selected.inventory[self.selected.inventory.selected].action,self.selected.inventory[self.selected.inventory.selected],1)
      if self.selected.inventory[self.selected.inventory.selected].consumable then
        table.remove(self.selected.inventory,self.selected.inventory.selected)
        self.selected.inventory.selected = math.min(self.selected.inventory.selected, #self.selected.inventory)
      end
    end
  else
    if cmd == 'm_run_away' then
    elseif cmd == 'm_attack' then
      self:attackTargetWithSelected(self.enemies[1],self.allies[1],{ name= "claws", damage= 30 })
    elseif cmd == 'm_end_turn' then
      self:endTurn()
    end
  end
end

function BattleScene:receiveCommandUpdate(command,dt)
end

function BattleScene:receiveCommandFinish(command)
  if cmd == 'm_run_away' then
    self:escapeBattle()
  elseif cmd == 'm_attack' then
    self:attackTargetWithSelected(self.enemies[1],self.allies[1],{ name= "claws", damage= 30 })
  elseif cmd == 'm_end_turn' then
    self:endTurn()
  end
end

function BattleScene:startBattle()
  self.target_guy = nil
  self.selected = self.allies[1]
  self.IS_PLAYER_TURN = true
end

function BattleScene:attackTargetWithSelected(attacker,target,weapon)
  target.health = target.health - weapon.damage
  if target.health < 0 then
    target.alive = false
  end
  self:endTurn()
end

function BattleScene:healTargetWithSelected(healer,target,method)
  target.health = math.min(target.max_health, target.health + method.heal)
  self:endTurn()
end

function BattleScene:scareTargetWithSelected(attacker,target,method)
  self:escapeBattle()
  self:endTurn()
end

function BattleScene:endTurn()
  local any_allies_alive = false
  for i = 1 , #self.allies do
    any_allies_alive = any_allies_alive or self.allies[i].alive
  end
  if not any_allies_alive then self:loseBattle() end

  local any_enemies_alive = false
  for i = 1 , #self.enemies do
    any_enemies_alive = any_enemies_alive or self.enemies[i].alive
  end
  if not any_enemies_alive then self:winBattle() end

  self.IS_PLAYER_TURN = not self.IS_PLAYER_TURN

  if not self.IS_PLAYER_TURN then
    self:doEnemyTurn()
  end
end

function BattleScene:doEnemyTurn()
  local monster = self.enemies[1]
  if monster.health < monster.max_health / 2 and math.random() > 0.9 then
    GS.input:addCommand("m_run_away",{desc = "The bear flees!"},1.2)
    GS.input:addCommand("m_end_turn")
  else
    GS.input:addCommand("m_attack",{desc = "The bear slashes at you"},1.0)
    GS.input:addCommand("m_end_turn")
  end
end

function BattleScene:winBattle()
  GS.input:addCommand("GAME_pop_battle")
end

function BattleScene:escapeBattle()
  GS.input:addCommand("GAME_pop_battle")
end

function BattleScene:loseBattle()
  GS.input:addCommand("GAME_lose")
end

function BattleScene:draw()
  --Set Font
  love.graphics.setFont(self.font)
  --Draw Background
  love.graphics.draw(Assets.img.battlescene.swamp.bg,0,0)
  local ally_x = love.graphics.getWidth()/5
  local enemy_x = 4 * love.graphics.getWidth()/5
  --Draw UI
  do
    love.graphics.push()
    if self.selected then
      love.graphics.setColor(0,0,0)
      --Draw Selected Guy Stats
      love.graphics.print(self.selected.name, self.ui_left, self.ui_level-350)
      love.graphics.setColor(100,100,200)
      love.graphics.rectangle('fill',self.ui_left-5,self.ui_level-305,310,35)
      love.graphics.setColor(0,0,255)
      love.graphics.rectangle('fill',self.ui_left,self.ui_level-300,300 * (self.selected.health/self.selected.max_health),25)
      love.graphics.setColor(255,255,255)
    end
    if self.target_guy then
      love.graphics.setColor(0,0,0)
      --Draw Selected Guy Stats
      love.graphics.print(self.target_guy.name, self.ui_right, self.ui_level-350)
      love.graphics.setColor(200,100,100)
      love.graphics.rectangle('fill',self.ui_right-5,self.ui_level-305,310,35)
      love.graphics.setColor(255,0,0)
      love.graphics.rectangle('fill',self.ui_right,self.ui_level-300,300 * (self.target_guy.health/self.target_guy.max_health),25)
      love.graphics.setColor(255,255,255)
    end
    --Draw Inventory
    for i = 1, #self.selected.inventory do
      love.graphics.push()
      love.graphics.translate(50 + i*100,self.ui_level)
      if self.selected.inventory.selected == i then 
        love.graphics.draw(Assets.img.entity_sheet,Assets.sprites.reticule.front,0,0,0,1,1,50)
      end
      self.selected.inventory[i]:draw()
      love.graphics.pop()
    end
    love.graphics.pop()
  end
  --Draw Visuals
  do
    love.graphics.push()
    --Draw Allied Combatants
    for i = 1, #self.allies do
      local ally = self.allies[i]
      love.graphics.push()
      love.graphics.translate(ally_x, self.ground_level - ally.sprite_height)
      ally.orient = "front"
      ally.facing = "right"
      ally:draw()
      love.graphics.pop()
    end
    --Draw Enemy Combatants
    for i = 1, #self.enemies do
      local enemy = self.enemies[i]
      love.graphics.push()
      love.graphics.translate(enemy_x, self.ground_level - enemy.sprite_height)
      enemy.orient = "front"
      enemy.facing = "left"
      enemy:draw()
      love.graphics.pop()
    end
    love.graphics.pop()
  end
end

return BattleScene

