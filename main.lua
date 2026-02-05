-- @author: lOobaid

local anim8 = require 'librairies/anim8'
local sti = require 'librairies/sti'

local game = {
    scale = 4,
    tileSize = 16,
    levels = {
        first = sti('resources/data/Levels/first.lua')
    }
}

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    player =  {
        x = 400,
        y = 300,
        speed = 4,
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

    player.currentAnim = player.animations.walkDown
end

function love.update(dt)
    fps = love.timer.getFPS()
    player.isMoving = false
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed
        player.isMoving = true
        player.currentAnim = player.animations.walkLeft
    end

    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed
        player.isMoving = true
        player.currentAnim = player.animations.walkRight
    end

    if love.keyboard.isDown("up") and player.isInLadder == true then
        player.y = player.y - player.speed
        player.isMoving = true
        player.currentAnim = player.animations.walkUp
    end

    if love.keyboard.isDown("down") and player.isInLadder == true then
        player.y = player.y + player.speed
        player.isMoving = true
        player.currentAnim = player.animations.walkDown
    end

    if player.isMoving == false then
        player.currentAnim:gotoFrame(2)
    end

    player.currentAnim:update(dt)
end

function love.draw()
    love.graphics.setColor(1, 1, 1) -- preventing something
    game.levels.first:draw()

    player.currentAnim:draw(player.spriteSheet, player.x, player.y, nil, game.scale)
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
