local class = require 'libs.middleclass'
local healthSpriteOptions = {
  width = 60,
  height = 20,
  numFrames = 11
}
local healthSpriteSheet = graphics.newImageSheet( "images/healthBar.png", healthSpriteOptions )
local healthSpriteData = {
  { name = "0", start=1, count=1, time=0,   loopCount=1 },
  { name = "10", start=2, count=1, time=0, loopCount=1 },
  { name = "20", start=3, count=1, time=0, loopCount=1 },
  { name = "30", start=4, count=1, time=0, loopCount=1 },
  { name = "40", start=5, count=1, time=0, loopCount=1 },
  { name = "50", start=6, count=1, time=0,   loopCount=1 },
  { name = "60", start=7, count=1, time=0, loopCount=1 },
  { name = "70", start=8, count=1, time=0, loopCount=1 },
  { name = "80", start=9, count=1, time=0, loopCount=1 },
  { name = "90", start=10, count=1, time=0, loopCount=1 },
  { name = "100", start=11, count=1, time=0, loopCount=1 }
}
local manaSpriteOptions = {
  width = 60,
  height = 20,
  numFrames = 11
}
local manaSpriteSheet = graphics.newImageSheet( "images/manaBar.png", manaSpriteOptions)
local manaSpriteData = {
  { name = "0",  start=1, count=1,  time=0,   loopCount=1 },
  { name = "10", start=2, count=1, time=0,   loopCount=1 },
  { name = "20", start=3, count=1, time=0,   loopCount=1 },
  { name = "30", start=4, count=1, time=0,   loopCount=1 },
  { name = "40", start=5, count=1, time=0,   loopCount=1 },
  { name = "50", start=6, count=1, time=0,   loopCount=1 },
  { name = "60", start=7, count=1, time=0,   loopCount=1 },
  { name = "70", start=8, count=1, time=0,   loopCount=1 },
  { name = "80", start=9, count=1, time=0,   loopCount=1 },
  { name = "90", start=10, count=1, time=0,  loopCount=1 },
  { name = "100", start=11, count=1, time=0, loopCount=1 }
}
Bar = class ('Bar')
function Bar:initialize(props)
  self.healthPos = {}
  self.manaPos = {}
  local healthPos = self.healthPos
  local manaPos = self.manaPos


  healthPos.x       = props.healthX or screenW - 460
  healthPos.y       = props.healthY or screenH - 300
  healthPos.scaleX  = props.healthScaleX or 2
  healthPos.scaleY  = props.healthScaleY or 1

  manaPos.x = props.manaX or screenW - 335
  manaPos.y = props.manaY or screenH - 300
  manaPos.scaleX = props.manaScaleX or 2
  manaPos.scaleY = props.manaScaleY or 1

  self.target = props.target


  self.sprite = props.sprite
end

function Bar:show()
  self.sprite = display.newGroup()
  local sprite = self.sprite
  local healthPos = self.healthPos
  local manaPos = self.manaPos
  -- Health Bar
  sprite.healthBar = display.newSprite(sprite, healthSpriteSheet, healthSpriteData)
  sprite.healthBar.x = healthPos.x
  sprite.healthBar.y = healthPos.y
  sprite.healthBar:scale(healthPos.scaleX, healthPos.scaleY)
  sprite.healthBar:setSequence("100")
  sprite.healthBar:play()
  -- Mana Bar
  sprite.manaBar = display.newSprite(sprite, manaSpriteSheet, manaSpriteData)
  sprite.manaBar.x = manaPos.x
  sprite.manaBar.y = manaPos.y
  sprite.manaBar:scale(manaPos.scaleX, manaPos.scaleY)
  sprite.manaBar:setSequence("100")
  sprite.manaBar:play()

  -- Score
  sprite.score = display.newText(self.target.score, screenW - 100, screenH - 305)
  sprite.score:setFillColor( 1, 0, 0.5 )
  -- Key
  sprite.key = display.newImage(sprite, "images/Key.png", 230, 15)
  sprite.key:scale(0.5,0.5)
  sprite.key.isVisible = false
  -- Bombs
  sprite.count = 0
  sprite.bomb = display.newImage(sprite, "images/Bomb.png", 420, 15)
  sprite.bomb:scale(0.5,0.5)
  sprite.bomb.count = display.newText(sprite, "x" .. sprite.count, 420, 15)
end

function Bar:setHealth(amt)
  local player = self.target
  local sprite = self.sprite
  -- Update Health
  player.health = player.health + amt
  -- Upper and Lower Bounds for Player Health
  if player.health < 0 then player.health = 0
  elseif player.health > 100 then player.health = 100 end

  if sprite then
    sprite.healthBar:setSequence("" .. player.health)
    sprite.healthBar:play()
  end
end

function Bar:setMana(amt)
  local player = self.target
  local sprite = self.sprite
  -- Update manaBar
  player.mana = player.mana + amt

  -- Upper and Lower Bounds for Player mana
  if player.mana < 0 then player.mana = 0
  elseif player.mana > 100 then player.mana = 100 end

  sprite.manaBar:setSequence("".. player.mana)
  sprite.manaBar:play()
end

function Bar:destroy()
  if self.sprite then
    self.sprite:removeSelf()
    self.sprite = nil
  end
end

-- Enemy Health Bars Subclass
eBar = class('eBar', Bar)
function eBar:initialize(props)
  self.target = props.target
  self.scaleX = 0.5
  self.scaleY = 0.5
end

function eBar:show()
  self.sprite = display.newGroup()
  local sprite = self.sprite
  local target = self.target
  sprite.healthBar = display.newSprite(sprite, healthSpriteSheet, healthSpriteData)
  sprite.healthBar.x = target.x
  sprite.healthBar.y = target.y - 20
  sprite.healthBar:scale(self.scaleX, self.scaleY)
  sprite.healthBar:setSequence("100")
  sprite.healthBar:play()
end

function eBar:move()
	if self.sprite then
	  if self.sprite.x and self.target.x then
		self.sprite.healthBar.x = self.target.x
		self.sprite.healthBar.y = self.target.y - 10
	  end
	 end
end
