---------------------------------------------------------------------------------
--
-- levelsScene.lua	: Loads the levels of the game ( SO FAR ONLY 1 :( )
--
---------------------------------------------------------------------------------

local sceneName = ...
local composer = require( "composer" )
local scene = composer.newScene( sceneName )

---------------------------------------------------------------------------------

-- start phyics up
physics.start()
physics.setGravity(0, 0)
-- Vars
local pauseImage
local backGround
local walls 
local Player
local Enemies
local Joystick
local pauseButton
local editType
local editImg
local editFilter
local editPhysics

function scene:create( event )
	local sceneGroup = self.view
	
	backGround			= event.params.bg or "images/testBG.png"
	pauseImage	= event.params.pauseImg or "images/pauseIcon.png"
	
	-- Create background
	bg = display.newImage(backGround)
	bg.rotation = 90
	sceneGroup:insert(bg)
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
		-- BG may change
		bg = event.params.bg or "images/testBG.png"
		-- LevelID
		levelID = 5
		-- Player
		Player = PlayerLib.NewPlayer( {} )
		sceneGroup:insert(Player)
		Player:spawnPlayer()
		-- Enemy
		Enemies = display.newGroup()
		sceneGroup:insert(Enemies)
		
		-- Joystick
		Joystick = StickLib.NewStick(
			{
				x             = 10,
				y             = screenH-(52),
				thumbSize     = 20,
				borderSize    = 32, 
				snapBackSpeed = .2, 
				R             = 0,
				G             = 1,
				B             = 1
			} 
		)
		sceneGroup:insert(Joystick)
		Joystick.alpha = 0.2
		-- Create some collision
		walls = display.newGroup()
		sceneGroup:insert(walls)
		
		pauseButton = display.newImage(pauseImage)
		pauseButton.x = display.contentWidth+20
		pauseButton.y = 21
		pauseButton.alpha = 0.2
		sceneGroup:insert(pauseButton)
	elseif phase == "did" then
		if Player and Joystick then
			function onMouseEvent( event )
				if not editType then
					editType = walls
					editImg = "images/crate.png"
					editFilter = worldCollisionFilter
					editPhysics = "static"
				end
				if event.isSecondaryButtonDown then
					ready = 1
					for n = 1, editType.numChildren, 1 do
						x1 = editType[n].x
						x2 = event.x
						y1 = editType[n].y
						y2 = event.y
						
						if math.sqrt(math.pow((x2-x1),2)+math.pow((y2-y1),2)) < 60 then
							ready = 0
						end
					end
					if (ready == 1) then
						if editFilter == worldCollisionFilter then
							crate = display.newImage(editImg, event.x, event.y)
							physics.addBody(crate, editPhysics, { filter = editFilter } )
							editType:insert(crate)
						elseif editFilter == enemyCollisionFilter then
							enemy = EnemyLib.NewEnemy( {x = event.x, y = event.y} )
							enemy:spawn()
							editType:insert(enemy)
							
						end
					end
				elseif event.isMiddleButtonDown then
					id = 0
					for n = 1, editType.numChildren, 1 do
						x1 = editType[n].x
						x2 = event.x
						y1 = editType[n].y
						y2 = event.y
						
						if math.sqrt(math.pow((x2-x1),2)+math.pow((y2-y1),2)) < 30 then
							id = n
						end
					end
					editType:remove(id)
				end
			end
			Runtime:addEventListener("mouse", onMouseEvent)
			function onKeyEvent( event )
				local key = event.keyName
				
				if key == "1" then
					print("walls")
					editType = walls
					editImg = "images/crate.png"
					editFilter = worldCollisionFilter
					editPhysics = "static"
				elseif key == "2" then
					print("enemies")
					editType = Enemies
					editFilter = enemyCollisionFilter
					editPhysics = "dynamic"
				elseif key == "deleteBack" then
					
				elseif key == "insert" then
					
				end
			end
			Runtime:addEventListener("key", onKeyEvent)
		
			function begin( event )
				Joystick:toFront()
				Player:move(Joystick)
				
				--move world if outside border
				if Player.x < -8 then	-- moving left
					Player.x = -8
					
					for n = 1, walls.numChildren, 1 do
						walls[n].x = walls[n].x + Player.speed
					end
					
					for n=1, Enemies.numChildren, 1 do
						Enemies[n].x = Enemies[n].x + Player.speed
					end
				end
				if Player.x > screenW+8 then	-- moving right
					Player.x = screenW+8
					
					for n = 1, walls.numChildren, 1 do
						walls[n].x = walls[n].x - Player.speed
					end
					
					for n=1, Enemies.numChildren, 1 do
						Enemies[n].x = Enemies[n].x - Player.speed
					end
				end
				if Player.y < borders then	-- moving up
					Player.y = borders
					
					for n = 1, walls.numChildren, 1 do
						walls[n].y = walls[n].y + Player.speed
					end
					
					for n=1, Enemies.numChildren, 1 do
						Enemies[n].y = Enemies[n].y + Player.speed
					end
				end
				if Player.y > screenH-borders then	-- moving down
					Player.y = screenH-borders
					
					for n = 1, walls.numChildren, 1 do
						walls[n].y = walls[n].y - Player.speed
					end
					
					for n=1, Enemies.numChildren, 1 do
						Enemies[n].y = Enemies[n].y - Player.speed
					end
				end
			end
			Runtime:addEventListener("enterFrame", begin)
		end
		if pauseButton then
			function pauseButton:touch ( event )
        		local phase = event.phase
        		if "ended" == phase then
        			composer.gotoScene( "scenes.settingsScene", { effect = "fade", time = 300 } )
        		end
        	end
        	pauseButton:addEventListener( "touch", pauseButton )
		end
    end 
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
		if pauseButton then
			pauseButton:removeEventListener("touch", pauseButton)
		end
		if Player then
			Runtime:removeEventListener("enterFrame", begin)
			Runtime:removeEventListener("mouse", onMouseEvent)
			Runtime:removeEventListener("key", onKeyEvent)
			Player:destroy()
		end
		if Joystick then
			Joystick:delete()
		end
		if walls then
			walls:removeSelf()
			walls = nil
		end
		if Enemies[1] then
			Enemies[1]:destroy()
		end
		if editType then
			editType:removeSelf()
			editType = nil
		end
    elseif phase == "did" then
	
    end 
end

function scene:destroy( event )
    local sceneGroup = self.view
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene