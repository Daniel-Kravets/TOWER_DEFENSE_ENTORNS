local slots = {}
local towers = {}
local enemies = {}
local enemySpawnTimer = 0

function love.load()
    love.graphics.setBackgroundColor(0.15, 0.18, 0.15)

    slots = {
        {x = 220, y = 180, size = 40, occupied = false},
        {x = 420, y = 320, size = 40, occupied = false},
        {x = 620, y = 180, size = 40, occupied = false}
    }
end

function spawnEnemy()
    table.insert(enemies, {
        x = -30,
        y = 270,
        radius = 15,
        speed = 80
    })
end

function love.update(dt)
    enemySpawnTimer = enemySpawnTimer + dt

    if enemySpawnTimer >= 2 then
        spawnEnemy()
        enemySpawnTimer = 0
    end

    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        enemy.x = enemy.x + enemy.speed * dt

        if enemy.x > 990 then
            table.remove(enemies, i)
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Forest Guardians - Prototip Fase 3", 20, 20)

    love.graphics.setColor(0.55, 0.45, 0.3)
    love.graphics.rectangle("fill", 0, 230, 960, 80)

    for _, slot in ipairs(slots) do
        if slot.occupied then
            love.graphics.setColor(0.2, 0.7, 0.2)
        else
            love.graphics.setColor(0.8, 0.8, 0.3)
        end
        love.graphics.rectangle("fill", slot.x, slot.y, slot.size, slot.size)
    end

    for _, tower in ipairs(towers) do
        love.graphics.setColor(0.2, 0.4, 0.9)
        love.graphics.circle("fill", tower.x, tower.y, 18)
    end

    for _, enemy in ipairs(enemies) do
        love.graphics.setColor(0.8, 0.2, 0.2)
        love.graphics.circle("fill", enemy.x, enemy.y, enemy.radius)
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        for _, slot in ipairs(slots) do
            if not slot.occupied and
                x >= slot.x and x <= slot.x + slot.size and
                y >= slot.y and y <= slot.y + slot.size then

                slot.occupied = true
                table.insert(towers, {
                    x = slot.x + slot.size / 2,
                    y = slot.y + slot.size / 2
                })
                break
            end
        end
    end
end