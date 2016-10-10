---------------------------------------------------------------------------------
--
-- main.lua	: Begin the application by showing the Welcome Screen
--
---------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )
system.activate( "multitouch" )

-- require the composer library
local composer = require "composer"

-- objects that should appear on all scenes below (e.g. tab bar, hud, etc)

-- system wide event handlers, location, key events, system resume/suspend, memory, etc.
screenW = display.contentWidth
screenH = display.contentHeight
halfW = screenW/2
halfH = screenH/2
borders = 40
-- Physics
physics = require("physics")
worldCollisionFilter = {categoryBits = 1, maskBits = 6}
playerCollisionFilter = { categoryBits = 2, maskBits = 1 }
powerCollisionFilter = { categoryBits = 4, maskBits = 5 }
-- Classes
StickLib = require("lib_analog_stick")
PlayerLib = require("Player")
PowerLib = require("Power")
ItemsLib = require("Items")

-- load Welcome Screen
composer.gotoScene( "welcomeScene" )