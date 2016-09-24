--
-- love.load()

function love.load()
    
    -- One-off random seed
    math.randomseed(os.time())

    font = love.graphics.newFont('assets/font/Share-TechMono.ttf',17)
    love.graphics.setFont(font)
    love.graphics.setColor( 0, 255, 0 )

    -- Load all sounds in a table
    keyboardSounds = { }
    for i=1,13 do
        fileName = string.format("assets/sound/k%s.ogg", i)
        keyboardSounds[i] = love.audio.newSource(fileName, "static")
    end

    robcoHeader = "Initializing Robco Industries(TM) MF Boot Agent v2.3.0\nRETROS BIOS\nRBIOS-4.02.08.00 52EE5.E7.E8\nCopyright 2201-2203 Robco Ind.\nUppermem: 64 KB\nRoot (5A8)\nWelcome to ROBCO Industries (TM) Termlink\n"

    ticks           = 0
    timerThreshold  = 0.5
    typeTimer       = timerThreshold
    typePos         = 0
    printedText     = ""

end

--
-- love.update()

function love.update(dt)

    -- ESC quits
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    -- Emulate terminal printing by pausing
    -- a random but normally distributed interval 
    -- between printing output to screen.

    typeTimer = typeTimer - get_random_internal()
    if typePos <= string.len(robcoHeader) then
        if typeTimer <= -1*timerThreshold or typeTimer >= timerThreshold then
            typeTimer    = timerThreshold
            typePos = typePos + 1
            printedText  = string.sub(robcoHeader,0,typePos)
            
            -- Play tick sound effect
            if ticks % 1 == 0 then
                keyboardSounds[8]:play()
            end                
            
            ticks=ticks+1
        end        
    end
end

--
-- love.draw()

function love.draw() 
        love.graphics.print( printedText,0,0 )
end

-- Other functions

-- Get a random wait interval but normall distributed, 
-- essentially a hacked Box-Muller transform.

function get_random_internal()
    return math.sqrt(-2 * math.log(math.random())) * math.cos(2 * math.pi * math.random()) / 2
end
