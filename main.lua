-- @author: lOobaid

local anim8 = require 'librairies/anim8'
local sti = require 'librairies/sti'
--local shaders = require 'shaders'
local wf = require 'librairies/windfield'
local mapFiles = {
    first = require 'resources/data/Levels/first'
}

local game = {
    scale = 4,
    tileSize = 16,
    world = wf.newWorld(0, 0),
    levels = {
        first = sti('resources/data/Levels/first.lua')
    }
}

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    player =  {
        x = mapFiles.first.layers[3].objects[3].x,
        y = mapFiles.first.layers[3].objects[3].y,
        speed = 250,
        spriteSheet = love.graphics.newImage('resources/assets/player.png'),
        isInLadder = false
    }

    player.animationGrid = anim8.newGrid(16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    player.animations = {
        walkDown = anim8.newAnimation(player.animationGrid('1-3', 1), 0.1),
        walkUp = anim8.newAnimation(player.animationGrid('1-3', 2), 0.1),
        walkLeft = anim8.newAnimation(player.animationGrid('1-3', 3), 0.1),
        walkRight = anim8.newAnimation(player.animationGrid('1-3', 4), 0.1)
    }
    player.collider = game.world:newBSGRectangleCollider(player.x - 64, player.y - 64, 50, 100, 10)
    player.collider:setFixedRotation(true)
    player.currentAnim = player.animations.walkDown

    door = {
        texture = love.graphics.newImage('resources/assets/sprites/door.png')
    }

    book = {
        texture = love.graphics.newImage('resources/assets/sprites/book.png')
    }
end

function love.update(dt)
    fps = love.timer.getFPS()
    player.isMoving = false
    local vx = 0
    local vy = 0

    if love.keyboard.isDown("left") and player.x - 64 >= 0 then
        vx = player.speed * -1
        player.isMoving = true
        player.currentAnim = player.animations.walkLeft
    end

    if love.keyboard.isDown("right") and player.x <= 640 then
        vx = player.speed
        player.isMoving = true
        player.currentAnim = player.animations.walkRight
    end

    if love.keyboard.isDown("up") and player.isInLadder == true then
        vy = player.speed * -1
        player.isMoving = true
        player.currentAnim = player.animations.walkUp
    end

    if love.keyboard.isDown("down") and player.isInLadder == true then
        vy = player.speed
        player.isMoving = true
        player.currentAnim = player.animations.walkDown
    end

    if player.isMoving == false then
        player.currentAnim:gotoFrame(2)
    end

    player.collider:setLinearVelocity(vx, vy)
    game.world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()
    player.currentAnim:update(dt)
end

function love.draw()
    love.graphics.setColor(1, 1, 1) -- preventing something
    game.levels.first:draw()
    for i, s in ipairs(mapFiles.first.layers[3].objects) do -- for the objects in the game
        if s.name == "door" then
            love.graphics.draw(door.texture, s.x, s.y, nil, game.scale, nil, 16, 16)
        end
        if s.name == "book" then
            love.graphics.draw(book.texture, s.x, s.y, nil, game.scale, nil, 16, 16)
        end
    end
    player.currentAnim:draw(player.spriteSheet, player.x, player.y, nil, game.scale, nil, 16, 16)

    game.world:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("FPS: "..tostring(fps), 10, 10) -- the 10s are x and y
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.push("quit")
    end
    
    if key == "down" then
        player.currentAnim = player.animations.walkDown
    end

    if key == "up" then
        player.currentAnim = player.animations.walkUp
    end
end
