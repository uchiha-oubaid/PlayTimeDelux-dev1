-- @author: lOobaid

local anim8 = require 'librairies/anim8'
local game = {
    scale = 4
}

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    player =  {
        x = 400,
        y = 300,
        speed = 4,
        spriteSheet = love.graphics.newImage('resources/assets/player.png'),
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
    player.isMoving = false
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed  -- for Animations
        player.isMoving = true
        player.currentAnim = player.animations.walkLeft
    end

    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed
        player.isMoving = true
        player.currentAnim = player.animations.walkRight
    end

    if player.isMoving == false then
        player.currentAnim = player.animations.walkDown
        player.currentAnim:gotoFrame(2)
    end

    player.currentAnim:update(dt)
end

function love.draw()
    player.currentAnim:draw(player.spriteSheet, player.x, player.y, nil, game.scale)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.push("quit")
    end
end
