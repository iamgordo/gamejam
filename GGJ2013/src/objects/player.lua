-- the player object that moves around the screen

require("core/object")

Player = class("Player", Object)

function Player:__init()
    self.x = 0
    self.y = 0
    self.z = 1
    self.angle = 0
end

function Player:update(dt)
    local mx, my = main:getMousePosition()
    self.angle = math.atan2(my - self.y, mx - self.x)

    local dx, dy = 0, 0
    if love.keyboard.isDown("a") then dx = dx - 1 end
    if love.keyboard.isDown("d") then dx = dx + 1 end
    if love.keyboard.isDown("w") then dy = dy - 1 end
    if love.keyboard.isDown("s") then dy = dy + 1 end

    local speed = 100
    self.x = self.x + dx * speed * dt
    self.y = self.y + dy * speed * dt

    main.centerX = self.x
    main.centerY = self.y
end

function Player:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(resources.images.player, self.x, self.y, self.angle, 1, 1, resources.images.player:getWidth() / 2, resources.images.player:getHeight() / 2)
end