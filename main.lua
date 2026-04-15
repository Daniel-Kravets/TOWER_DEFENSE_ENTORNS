local slots = {}
local towers = {}

function love.load()
    love.graphics.setBackgroundColor(0.15, 0.18, 0.15)

    slots = {
        {x = 220, y = 180, size = 40, occupied = false},
        {x = 420, y = 260, size = 40, occupied = false},
        {x = 620, y = 180, size = 40, occupied = false}
    }
end

function love.update(dt)
end

function love.draw()
    -- Títol
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Forest Guardians - Prototip Fase 3", 20, 20)

    -- Camí
    love.graphics.setColor(0.55, 0.45, 0.3)
    love.graphics.rectangle("fill", 0, 230, 960, 80)

    -- Slots de construcció
    for _, slot in ipairs(slots) do
        if slot.occupied then
            love.graphics.setColor(0.2, 0.7, 0.2)
        else
            love.graphics.setColor(0.8, 0.8, 0.3)
        end
        love.graphics.rectangle("fill", slot.x, slot.y, slot.size, slot.size)
    end

    -- Torres
    for _, tower in ipairs(towers) do
        love.graphics.setColor(0.2, 0.4, 0.9)
        love.graphics.circle("fill", tower.x, tower.y, 18)
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