-- ============================================================
-- LAYOUT CONSTANTS
-- ============================================================
local PATH_WIDTH  = 52
local TOTAL_WAVES = 10
local BASE_HP_MAX = 20
local WAVE_GAP    = 6
local HUD_TOP     = 68
local HUD_BOT_Y   = 472
local HUD_BOT_H   = 68

-- ============================================================
-- MAP DATA
-- ============================================================
local PATH = {
    {x=-20, y=120},{x=110,y=120},{x=110,y=440},{x=340,y=440},
    {x=340,y=180},{x=570,y=180},{x=570,y=440},{x=760,y=440},
    {x=760,y=270},{x=990,y=270},
}

local ENEMY_DEFS = {
    normal={radius=15,speed=80, health=4, reward=10,baseDmg=1,color={0.82,0.16,0.16}},
    fast  ={radius=11,speed=150,health=2, reward=15,baseDmg=1,color={0.95,0.65,0.10}},
    tank  ={radius=20,speed=40, health=14,reward=30,baseDmg=2,color={0.28,0.28,0.82}},
}

local DECORATIONS = {
    {type="tree",  x=50, y=350,r=22},{type="tree",  x=55, y=462,r=20},
    {type="tree",  x=225,y=462,r=18},{type="tree",  x=490,y=462,r=20},
    {type="tree",  x=700,y=462,r=22},{type="tree",  x=900,y=462,r=18},
    {type="tree",  x=910,y=82, r=18},{type="tree",  x=275,y=86, r=20},
    {type="tree",  x=680,y=86, r=18},{type="bush",  x=50, y=210,r=10},
    {type="bush",  x=160,y=462,r=9}, {type="bush",  x=390,y=82, r=9},
    {type="bush",  x=500,y=355,r=10},{type="bush",  x=720,y=82, r=10},
    {type="bush",  x=855,y=195,r=9}, {type="rock",  x=185,y=165,r=7},
    {type="rock",  x=460,y=462,r=6}, {type="rock",  x=800,y=90, r=7},
    {type="flower",x=70, y=270,r=5}, {type="flower",x=240,y=290,r=5},
    {type="flower",x=460,y=140,r=5}, {type="flower",x=660,y=210,r=5},
    {type="flower",x=840,y=410,r=5},
}

-- ============================================================
-- TOWER DEFINITIONS
-- ============================================================
-- cols: {outer, mid, gem} color per level
-- ups:  per-level stats; cost = gold to reach that level from previous
local TOWER_DEFS = {
    basic = {
        name = "Torre Basica", cost = 30,
        cols = {
            {{0.15,0.22,0.65},{0.28,0.45,0.92},{0.55,0.72,1.00}},
            {{0.18,0.28,0.75},{0.35,0.55,0.95},{0.62,0.80,1.00}},
            {{0.22,0.35,0.85},{0.42,0.65,1.00},{0.72,0.88,1.00}},
            {{0.28,0.42,0.92},{0.52,0.74,1.00},{0.88,0.96,1.00}},
        },
        ups = {
            {damage=1,range=140,atkSpeed=0.80,cost=0},
            {damage=2,range=155,atkSpeed=0.70,cost=25},
            {damage=3,range=175,atkSpeed=0.60,cost=40},
            {damage=5,range=195,atkSpeed=0.50,cost=65},
        },
    },
    archer = {
        name = "Torre Arquera", cost = 50,
        cols = {
            {{0.10,0.42,0.15},{0.20,0.62,0.25},{0.45,0.88,0.50}},
            {{0.12,0.50,0.18},{0.25,0.72,0.30},{0.55,0.92,0.58}},
            {{0.15,0.58,0.22},{0.30,0.82,0.36},{0.62,0.95,0.65}},
            {{0.18,0.65,0.26},{0.38,0.92,0.44},{0.75,1.00,0.78}},
        },
        ups = {
            {damage=2,range=200,atkSpeed=1.00,cost=0},
            {damage=3,range=220,atkSpeed=0.85,cost=35},
            {damage=5,range=245,atkSpeed=0.70,cost=55},
            {damage=8,range=270,atkSpeed=0.55,cost=90},
        },
    },
    magic = {
        name = "Torre Magica", cost = 80,
        cols = {
            {{0.42,0.10,0.62},{0.62,0.22,0.88},{0.82,0.52,1.00}},
            {{0.48,0.12,0.70},{0.70,0.28,0.94},{0.88,0.60,1.00}},
            {{0.55,0.15,0.78},{0.78,0.35,1.00},{0.92,0.68,1.00}},
            {{0.62,0.18,0.85},{0.85,0.42,1.00},{0.96,0.78,1.00}},
        },
        ups = {
            {damage=4,range=120,atkSpeed=1.80,cost=0},
            {damage=6,range=135,atkSpeed=1.50,cost=50},
            {damage=9,range=150,atkSpeed=1.20,cost=80},
            {damage=14,range=170,atkSpeed=1.00,cost=120},
        },
    },
}

-- ============================================================
-- STATE
-- ============================================================
local fontTiny, fontSmall, fontMedium, fontLarge, fontHuge

local slots           = {}
local towers          = {}
local enemies         = {}
local spawnQueue      = {}
local selectedTower   = nil   -- tower table currently inspected
local selectedTType   = "basic"

local currentWave       = 0
local waveState         = "countdown"
local countdownTimer    = 0
local spawnTimer        = 0
local spawnInterval     = 1.0
local baseHP            = BASE_HP_MAX
local gold              = 150
local waveBonus         = 0
local bonusTimer        = 0
local waveAnnounceTimer = 0
local waveAnnounceText  = ""

-- ============================================================
-- RESET / LOAD
-- ============================================================
local function resetGame()
    towers={} enemies={} spawnQueue={}
    selectedTower=nil selectedTType="basic"
    currentWave=0 waveState="countdown" countdownTimer=4
    spawnTimer=0 spawnInterval=1.0
    baseHP=BASE_HP_MAX gold=150
    waveBonus=0 bonusTimer=0 waveAnnounceTimer=0 waveAnnounceText=""
    for _,s in ipairs(slots) do s.occupied=false end
end

function love.load()
    love.graphics.setBackgroundColor(0.22,0.44,0.18)
    fontTiny   = love.graphics.newFont(11)
    fontSmall  = love.graphics.newFont(13)
    fontMedium = love.graphics.newFont(16)
    fontLarge  = love.graphics.newFont(20)
    fontHuge   = love.graphics.newFont(46)
    slots = {
        {x=175,y=230,size=40,occupied=false},
        {x=200,y=335,size=40,occupied=false},
        {x=420,y=82, size=40,occupied=false},
        {x=440,y=300,size=40,occupied=false},
        {x=620,y=82, size=40,occupied=false},
        {x=640,y=315,size=40,occupied=false},
        {x=820,y=82, size=40,occupied=false},
        {x=840,y=365,size=40,occupied=false},
    }
    resetGame()
end

-- ============================================================
-- WAVE MANAGEMENT
-- ============================================================
local function buildSpawnQueue(waveNum)
    local queue={} local count=5+waveNum*2
    local hpMult=1+(waveNum-1)*0.45 local spdMult=1+(waveNum-1)*0.06
    local interval=math.max(0.35,1.1-(waveNum-1)*0.08)
    for i=1,count do
        local etype="normal"
        if waveNum>=2 and i%4==0 then etype="fast" end
        if waveNum>=3 and i%5==0 then etype="tank" end
        local def=ENEMY_DEFS[etype]
        local hp=math.max(1,math.floor(def.health*hpMult+0.5))
        table.insert(queue,{etype=etype,radius=def.radius,speed=def.speed*spdMult,
            health=hp,maxHealth=hp,color=def.color,reward=def.reward,baseDmg=def.baseDmg})
    end
    return queue,interval
end

-- ============================================================
-- HELPERS
-- ============================================================
local function dist(x1,y1,x2,y2)
    local dx,dy=x2-x1,y2-y1 return math.sqrt(dx*dx+dy*dy)
end

-- Returns popup rect (px,py,pw,ph) for a given tower, or nil if no tower
local function popupRect(t)
    if not t then return nil end
    local r0=18+(t.level-1)*1.5
    local pw,ph=228,94
    local px=t.x-pw/2
    local py
    if t.y+r0+12+ph < HUD_BOT_Y-4 then py=t.y+r0+10
    else py=t.y-r0-12-ph end
    px=math.max(5,math.min(955-pw,px))
    py=math.max(HUD_TOP+5,math.min(HUD_BOT_Y-ph-5,py))
    return px,py,pw,ph
end

local function upgradeTower(t)
    local def=TOWER_DEFS[t.towerType]
    if t.level>=#def.ups then return end
    local cost=def.ups[t.level+1].cost
    if gold<cost then return end
    gold=gold-cost
    t.totalCost=t.totalCost+cost
    t.level=t.level+1
    local lv=def.ups[t.level]
    t.damage=lv.damage t.range=lv.range t.attackSpeed=lv.atkSpeed
end

local function sellTower(t)
    local refund=math.floor(t.totalCost*0.5)
    gold=gold+refund
    t.slot.occupied=false
    for i,v in ipairs(towers) do
        if v==t then table.remove(towers,i) break end
    end
    selectedTower=nil
end

-- ============================================================
-- UPDATE
-- ============================================================
function love.update(dt)
    if waveState=="gameover" or waveState=="victory" then return end
    if bonusTimer>0        then bonusTimer=bonusTimer-dt end
    if waveAnnounceTimer>0 then waveAnnounceTimer=waveAnnounceTimer-dt end

    if waveState=="countdown" then
        countdownTimer=countdownTimer-dt
        if countdownTimer<=0 then
            currentWave=currentWave+1
            spawnQueue,spawnInterval=buildSpawnQueue(currentWave)
            spawnTimer=0 waveState="spawning"
            waveAnnounceText="OLEADA  "..currentWave
            waveAnnounceTimer=2.8
        end
        return
    end

    if waveState=="spawning" then
        spawnTimer=spawnTimer+dt
        if spawnTimer>=spawnInterval and #spawnQueue>0 then
            local s=table.remove(spawnQueue,1)
            table.insert(enemies,{x=PATH[1].x,y=PATH[1].y,
                radius=s.radius,speed=s.speed,health=s.health,maxHealth=s.maxHealth,
                color=s.color,reward=s.reward,baseDmg=s.baseDmg,waypointIndex=2})
            spawnTimer=0
        end
        if #spawnQueue==0 then waveState="fighting" end
    end

    for i=#enemies,1,-1 do
        local e=enemies[i]
        if e.waypointIndex>#PATH then
            baseHP=math.max(0,baseHP-e.baseDmg)
            table.remove(enemies,i)
            if baseHP<=0 then waveState="gameover" return end
        else
            local t=PATH[e.waypointIndex]
            local dx,dy=t.x-e.x,t.y-e.y
            local d=math.sqrt(dx*dx+dy*dy)
            if d<4 then e.waypointIndex=e.waypointIndex+1
            else e.x=e.x+(dx/d)*e.speed*dt e.y=e.y+(dy/d)*e.speed*dt end
        end
    end

    for _,tower in ipairs(towers) do
        tower.cooldown=tower.cooldown-dt
        if tower.cooldown<=0 then
            for i=#enemies,1,-1 do
                local e=enemies[i]
                if dist(tower.x,tower.y,e.x,e.y)<=tower.range then
                    e.health=e.health-tower.damage
                    tower.cooldown=tower.attackSpeed
                    if e.health<=0 then gold=gold+e.reward table.remove(enemies,i) end
                    break
                end
            end
        end
    end

    if waveState=="fighting" and #enemies==0 then
        if currentWave>=TOTAL_WAVES then waveState="victory"
        else
            local bonus=20+currentWave*10
            gold=gold+bonus waveBonus=bonus bonusTimer=3.2
            countdownTimer=WAVE_GAP waveState="countdown"
        end
    end
end

-- ============================================================
-- ICON HELPERS
-- ============================================================
local function iconCoin(x,y,r)
    love.graphics.setColor(0.18,0.14,0.02) love.graphics.circle("fill",x+1,y+1,r)
    love.graphics.setColor(0.98,0.80,0.12) love.graphics.circle("fill",x,y,r)
    love.graphics.setColor(0.70,0.56,0.08) love.graphics.setLineWidth(1.5)
    love.graphics.circle("line",x,y,r)
    love.graphics.setColor(1,0.95,0.55) love.graphics.circle("fill",x-r*0.3,y-r*0.3,r*0.38)
end

local function iconHeart(x,y,s,r,g,b,a)
    love.graphics.setColor(r,g,b,a or 1)
    love.graphics.circle("fill",x-s*2.8,y-s*1.5,s*3.5)
    love.graphics.circle("fill",x+s*2.8,y-s*1.5,s*3.5)
    love.graphics.polygon("fill",x-s*6,y-s*0.5, x+s*6,y-s*0.5, x,y+s*6)
end

local function iconSkull(x,y,r)
    love.graphics.setColor(0.85,0.18,0.10)
    love.graphics.circle("fill",x,y-r*0.25,r*0.85)
    love.graphics.rectangle("fill",x-r*0.62,y+r*0.25,r*1.24,r*0.55,2)
    love.graphics.setColor(0.08,0.05,0.04)
    love.graphics.circle("fill",x-r*0.32,y-r*0.3,r*0.24)
    love.graphics.circle("fill",x+r*0.32,y-r*0.3,r*0.24)
    love.graphics.rectangle("fill",x-r*0.46,y+r*0.46,r*0.28,r*0.32)
    love.graphics.rectangle("fill",x-r*0.10,y+r*0.46,r*0.28,r*0.32)
    love.graphics.rectangle("fill",x+r*0.26,y+r*0.46,r*0.28,r*0.32)
end

local function iconCastle(x,y,s)
    love.graphics.setColor(0.52,0.48,0.40)
    love.graphics.rectangle("fill",x-s*5,y-s*3,s*10,s*8,1)
    love.graphics.setColor(0.62,0.57,0.48)
    love.graphics.rectangle("fill",x-s*5,y-s*3,s*10,s*3,1)
    for k=0,2 do
        love.graphics.setColor(0.50,0.46,0.38)
        love.graphics.rectangle("fill",x-s*5+k*s*4,y-s*7,s*3,s*5,1)
    end
    love.graphics.setColor(0.18,0.12,0.08)
    love.graphics.rectangle("fill",x-s*1.5,y+s*0.5,s*3,s*4,1)
end

-- ============================================================
-- WORLD DRAW HELPERS
-- ============================================================
local function drawPath()
    love.graphics.setColor(0.22,0.16,0.08)
    love.graphics.setLineWidth(PATH_WIDTH+12) love.graphics.setLineJoin("miter")
    for i=1,#PATH-1 do love.graphics.line(PATH[i].x,PATH[i].y,PATH[i+1].x,PATH[i+1].y) end
    for _,p in ipairs(PATH) do love.graphics.circle("fill",p.x,p.y,(PATH_WIDTH+12)/2) end
    love.graphics.setColor(0.62,0.50,0.32) love.graphics.setLineWidth(PATH_WIDTH)
    for i=1,#PATH-1 do love.graphics.line(PATH[i].x,PATH[i].y,PATH[i+1].x,PATH[i+1].y) end
    for _,p in ipairs(PATH) do love.graphics.circle("fill",p.x,p.y,PATH_WIDTH/2) end
    love.graphics.setColor(0.70,0.58,0.40,0.48) love.graphics.setLineWidth(PATH_WIDTH*0.34)
    for i=1,#PATH-1 do love.graphics.line(PATH[i].x,PATH[i].y,PATH[i+1].x,PATH[i+1].y) end
    love.graphics.setColor(1,0.85,0.2,0.9) love.graphics.setLineWidth(3)
    local ay=PATH[1].y
    love.graphics.line(8,ay,28,ay) love.graphics.line(22,ay-8,28,ay) love.graphics.line(22,ay+8,28,ay)
end

local function drawDecorations()
    for _,d in ipairs(DECORATIONS) do
        if d.type=="tree" then
            love.graphics.setColor(0.42,0.26,0.10)
            love.graphics.rectangle("fill",d.x-4,d.y-6,8,d.r)
            love.graphics.setColor(0.14,0.35,0.10) love.graphics.circle("fill",d.x,d.y-d.r*0.6,d.r+3)
            love.graphics.setColor(0.20,0.55,0.16) love.graphics.circle("fill",d.x,d.y-d.r*0.6,d.r)
            love.graphics.setColor(0.30,0.70,0.24) love.graphics.circle("fill",d.x-3,d.y-d.r*0.6-5,d.r*0.52)
        elseif d.type=="bush" then
            love.graphics.setColor(0.16,0.44,0.12)
            love.graphics.circle("fill",d.x,d.y,d.r+2)
            love.graphics.circle("fill",d.x-d.r*0.7,d.y,d.r*0.75)
            love.graphics.circle("fill",d.x+d.r*0.7,d.y,d.r*0.75)
            love.graphics.setColor(0.26,0.60,0.20)
            love.graphics.circle("fill",d.x,d.y,d.r)
            love.graphics.circle("fill",d.x-d.r*0.6,d.y,d.r*0.65)
            love.graphics.circle("fill",d.x+d.r*0.6,d.y,d.r*0.65)
        elseif d.type=="rock" then
            love.graphics.setColor(0.35,0.33,0.30) love.graphics.circle("fill",d.x+1,d.y+2,d.r)
            love.graphics.setColor(0.55,0.52,0.48) love.graphics.circle("fill",d.x,d.y,d.r)
            love.graphics.setColor(0.70,0.68,0.64) love.graphics.circle("fill",d.x-2,d.y-2,d.r*0.45)
        elseif d.type=="flower" then
            love.graphics.setColor(0.95,0.85,0.25)
            for k=0,4 do
                local a=k*(math.pi*2/5)
                love.graphics.circle("fill",d.x+math.cos(a)*d.r*1.4,d.y+math.sin(a)*d.r*1.4,d.r*0.7)
            end
            love.graphics.setColor(1,0.55,0.15) love.graphics.circle("fill",d.x,d.y,d.r*0.65)
        end
    end
end

local function drawBase()
    local bx,by=920,PATH[#PATH].y
    local tint=1-math.max(0,(baseHP/BASE_HP_MAX-0.25)/0.75)
    love.graphics.setColor(0.10,0.08,0.05,0.55)
    love.graphics.rectangle("fill",bx-27,by-27,58,58,5,5)
    love.graphics.setColor(0.48+tint*0.22,0.44-tint*0.22,0.36-tint*0.22)
    love.graphics.rectangle("fill",bx-25,by-25,54,54,4,4)
    love.graphics.setColor(0.62+tint*0.2,0.57-tint*0.2,0.46-tint*0.2)
    love.graphics.rectangle("fill",bx-25,by-25,54,16,4,4)
    love.graphics.setColor(0.52,0.47,0.38)
    for k=0,3 do love.graphics.rectangle("fill",bx-22+k*14,by-38,10,16,2,2) end
    love.graphics.setColor(0.25,0.18,0.10) love.graphics.rectangle("fill",bx-8,by+2,18,22,4,4)
    love.graphics.setColor(0.18,0.12,0.07) love.graphics.rectangle("fill",bx-6,by+4,14,18,3,3)
    love.graphics.setColor(0.62,0.60,0.56) love.graphics.setLineWidth(2)
    love.graphics.line(bx+16,by-52,bx+16,by-25)
    local hp_pct=baseHP/BASE_HP_MAX
    love.graphics.setColor(0.9-hp_pct*0.4,0.1+hp_pct*0.5,0.1)
    love.graphics.polygon("fill",bx+16,by-52,bx+30,by-46,bx+16,by-40)
    love.graphics.setFont(fontTiny) love.graphics.setColor(1,0.9,0.5)
    love.graphics.print("BASE",bx-11,by-66)
end

local function drawSlots()
    for _,slot in ipairs(slots) do
        local cx=slot.x+slot.size/2 local cy=slot.y+slot.size/2 local r=slot.size/2+2
        love.graphics.setColor(0,0,0,0.25) love.graphics.circle("fill",cx+2,cy+3,r)
        if slot.occupied then
            love.graphics.setColor(0.20,0.52,0.20) love.graphics.circle("fill",cx,cy,r)
        else
            local def=TOWER_DEFS[selectedTType]
            local canAfford=(gold>=def.cost)
            love.graphics.setColor(canAfford and 0.88 or 0.45, canAfford and 0.85 or 0.40, 0.30,0.80)
            love.graphics.circle("fill",cx,cy,r)
            love.graphics.setColor(canAfford and 0.98 or 0.55, canAfford and 0.95 or 0.50,0.45)
            love.graphics.setLineWidth(2) love.graphics.circle("line",cx,cy,r)
            love.graphics.setColor(0.55,0.52,0.15) love.graphics.setLineWidth(3)
            love.graphics.line(cx-8,cy,cx+8,cy) love.graphics.line(cx,cy-8,cx,cy+8)
        end
    end
end

local function drawTowers()
    for _,t in ipairs(towers) do
        local def=TOWER_DEFS[t.towerType]
        local cols=def.cols[t.level]
        local r0=18+(t.level-1)*1.5
        local isSelected=(t==selectedTower)

        -- Range circle
        love.graphics.setColor(cols[1][1],cols[1][2],cols[1][3],0.08)
        love.graphics.circle("fill",t.x,t.y,t.range)
        love.graphics.setColor(cols[1][1],cols[1][2],cols[1][3],isSelected and 0.40 or 0.20)
        love.graphics.setLineWidth(isSelected and 1.5 or 1)
        love.graphics.circle("line",t.x,t.y,t.range)

        -- Selection pulse ring
        if isSelected then
            local pulse=0.55+math.sin(love.timer.getTime()*5)*0.45
            love.graphics.setColor(1,0.92,0.25,pulse)
            love.graphics.setLineWidth(3)
            love.graphics.circle("line",t.x,t.y,r0+8)
        end

        -- Shadow + body
        love.graphics.setColor(0,0,0,0.35) love.graphics.circle("fill",t.x+2,t.y+3,r0)
        love.graphics.setColor(cols[1][1]*0.55,cols[1][2]*0.55,cols[1][3]*0.55)
        love.graphics.circle("fill",t.x,t.y,r0)

        -- Level 3+ glow halo
        if t.level>=3 then
            love.graphics.setColor(cols[2][1],cols[2][2],cols[2][3],0.14)
            love.graphics.circle("fill",t.x,t.y,r0*1.25)
        end

        -- Mid ring
        love.graphics.setColor(cols[2][1],cols[2][2],cols[2][3])
        love.graphics.circle("fill",t.x,t.y,r0*0.75)

        -- Extra rings at higher levels
        if t.level>=2 then
            love.graphics.setColor(cols[1][1]*0.85,cols[1][2]*0.85,cols[1][3]*0.85,0.7)
            love.graphics.setLineWidth(2) love.graphics.circle("line",t.x,t.y,r0*0.87)
        end
        if t.level>=3 then
            love.graphics.setColor(cols[3][1],cols[3][2],cols[3][3],0.55)
            love.graphics.setLineWidth(1.5) love.graphics.circle("line",t.x,t.y,r0*0.95)
        end

        -- Gem core
        love.graphics.setColor(cols[3][1],cols[3][2],cols[3][3])
        love.graphics.circle("fill",t.x,t.y,r0*0.36)
        love.graphics.setColor(1,1,1,0.65) love.graphics.circle("fill",t.x-2,t.y-2,r0*0.15)

        -- Level 4 rotating gold dots
        if t.level==4 then
            for k=0,3 do
                local angle=k*(math.pi/2)+love.timer.getTime()*0.8
                love.graphics.setColor(1,0.85,0.15)
                love.graphics.circle("fill",t.x+math.cos(angle)*(r0+5),t.y+math.sin(angle)*(r0+5),3)
            end
        end

        -- Level indicator dots below tower
        local maxLv=#def.ups
        for k=1,maxLv do
            local ldx=t.x-(maxLv-1)*5+(k-1)*10
            local ldy=t.y+r0+8
            if k<=t.level then
                love.graphics.setColor(cols[3][1],cols[3][2],cols[3][3])
            else
                love.graphics.setColor(0.25,0.25,0.30)
            end
            love.graphics.circle("fill",ldx,ldy,3)
        end
    end
end

local function drawHPBar(ex,ey,r,hp,maxHp)
    local barW=r*2+6 local by=ey-r-10
    love.graphics.setColor(0.10,0.10,0.10,0.9)
    love.graphics.rectangle("fill",ex-barW/2,by,barW,5,2,2)
    local pct=hp/maxHp
    if pct>0.5 then love.graphics.setColor(0.18,0.85,0.18)
    elseif pct>0.25 then love.graphics.setColor(0.92,0.72,0.08)
    else love.graphics.setColor(0.92,0.16,0.10) end
    love.graphics.rectangle("fill",ex-barW/2,by,barW*pct,5,2,2)
end

local function drawEnemies()
    for _,e in ipairs(enemies) do
        local c=e.color
        love.graphics.setColor(0,0,0,0.28) love.graphics.circle("fill",e.x+3,e.y+3,e.radius)
        love.graphics.setColor(c[1],c[2],c[3]) love.graphics.circle("fill",e.x,e.y,e.radius)
        love.graphics.setColor(c[1]*0.52,c[2]*0.52,c[3]*0.52)
        love.graphics.setLineWidth(2) love.graphics.circle("line",e.x,e.y,e.radius)
        love.graphics.setColor(math.min(1,c[1]+0.35),math.min(1,c[2]+0.30),math.min(1,c[3]+0.30),0.60)
        love.graphics.circle("fill",e.x-3,e.y-3,e.radius*0.30)
        drawHPBar(e.x,e.y,e.radius,e.health,e.maxHealth)
    end
end

-- ============================================================
-- HUD DRAW
-- ============================================================
local function sep(x)
    love.graphics.setColor(0.28,0.32,0.38,0.7)
    love.graphics.setLineWidth(1) love.graphics.line(x,8,x,HUD_TOP-8)
end

local function drawTopBar()
    love.graphics.setColor(0,0,0,0.55) love.graphics.rectangle("fill",0,2,960,HUD_TOP)
    love.graphics.setColor(0.10,0.12,0.16) love.graphics.rectangle("fill",0,0,960,HUD_TOP)
    love.graphics.setColor(0.13,0.15,0.20) love.graphics.rectangle("fill",0,0,960,HUD_TOP/2)
    love.graphics.setColor(0.28,0.48,0.80,0.55) love.graphics.rectangle("fill",0,HUD_TOP-2,960,2)

    iconCastle(22,34,2.2)
    love.graphics.setFont(fontLarge) love.graphics.setColor(0.88,0.80,0.48)
    love.graphics.print("FOREST",42,8)
    love.graphics.setFont(fontTiny) love.graphics.setColor(0.52,0.54,0.58)
    love.graphics.print("GUARDIANS",43,32)
    sep(190)

    love.graphics.setFont(fontTiny) love.graphics.setColor(0.52,0.54,0.58)
    love.graphics.print("OLEADA",198,8)
    love.graphics.setFont(fontLarge)
    love.graphics.setColor(waveState=="countdown" and 0.55 or 0.40,
                           waveState=="countdown" and 0.88 or 0.72,
                           waveState=="countdown" and 0.55 or 1.0)
    local wn=(waveState=="countdown") and (currentWave+1) or currentWave
    love.graphics.print(wn.." / "..TOTAL_WAVES,198,22)
    for i=1,TOTAL_WAVES do
        local dx=196+(i-1)*16 local dy=54
        if i<=currentWave then
            love.graphics.setColor(0.35,0.62,1) love.graphics.circle("fill",dx,dy,5)
        elseif i==currentWave+1 and waveState=="countdown" then
            local pulse=0.70+math.sin(love.timer.getTime()*4)*0.30
            love.graphics.setColor(0.55,1,0.55,pulse) love.graphics.circle("fill",dx,dy,5)
        else
            love.graphics.setColor(0.28,0.30,0.36) love.graphics.circle("fill",dx,dy,5)
            love.graphics.setColor(0.35,0.38,0.45) love.graphics.setLineWidth(1)
            love.graphics.circle("line",dx,dy,5)
        end
    end
    if waveState=="countdown" then
        local pill="Siguiente en  "..math.ceil(countdownTimer).."s"
        love.graphics.setColor(0.06,0.20,0.10,0.85) love.graphics.rectangle("fill",195,42,168,20,5,5)
        love.graphics.setColor(0.20,0.75,0.30) love.graphics.setLineWidth(1)
        love.graphics.rectangle("line",195,42,168,20,5,5)
        love.graphics.setFont(fontTiny) love.graphics.setColor(0.55,1,0.55)
        love.graphics.print(pill,200,46)
    end
    sep(372)

    love.graphics.setFont(fontTiny) love.graphics.setColor(0.52,0.54,0.58)
    love.graphics.print("ENEMIGOS",406,8)
    local rem=#spawnQueue+#enemies
    iconSkull(389,32,10)
    love.graphics.setFont(fontLarge)
    love.graphics.setColor(rem>0 and 1 or 0.40, rem>0 and 0.48 or 0.70, rem>0 and 0.22 or 0.40)
    love.graphics.print(tostring(rem),406,22)
    sep(532)

    love.graphics.setFont(fontTiny) love.graphics.setColor(0.52,0.54,0.58)
    love.graphics.print("ORO",564,8)
    iconCoin(549,32,10)
    love.graphics.setFont(fontLarge) love.graphics.setColor(1,0.85,0.15)
    love.graphics.print(tostring(gold),564,22)
    sep(682)

    local hp_pct=baseHP/BASE_HP_MAX
    local hr=hp_pct>0.5 and 0.82 or (hp_pct>0.25 and 0.95 or 0.95)
    local hg=hp_pct>0.5 and 0.18 or (hp_pct>0.25 and 0.65 or 0.15)
    local hb=hp_pct>0.5 and 0.18 or (hp_pct>0.25 and 0.08 or 0.10)
    iconHeart(700,28,1.8,hr,hg,hb)
    love.graphics.setFont(fontTiny) love.graphics.setColor(0.52,0.54,0.58) love.graphics.print("BASE",716,8)
    love.graphics.setFont(fontMedium) love.graphics.setColor(hr+0.05,hg+0.05,hb+0.05)
    love.graphics.print(baseHP.." / "..BASE_HP_MAX,716,24)
    local bX,bY,bW,bH=790,14,158,18
    love.graphics.setColor(0.08,0.08,0.10) love.graphics.rectangle("fill",bX,bY,bW,bH,4,4)
    love.graphics.setColor(hr*0.4,hg*0.4,hb*0.4,0.6) love.graphics.rectangle("fill",bX,bY,bW,bH,4,4)
    love.graphics.setColor(hr,hg,hb) love.graphics.rectangle("fill",bX,bY,bW*hp_pct,bH,4,4)
    love.graphics.setColor(1,1,1,0.12) love.graphics.rectangle("fill",bX,bY,bW*hp_pct,bH/2,4,4)
    love.graphics.setColor(0.35,0.38,0.45) love.graphics.setLineWidth(1)
    love.graphics.rectangle("line",bX,bY,bW,bH,4,4)
end

local function drawBottomBar()
    love.graphics.setColor(0,0,0,0.50) love.graphics.rectangle("fill",0,HUD_BOT_Y-3,960,HUD_BOT_H+3)
    love.graphics.setColor(0.10,0.12,0.16) love.graphics.rectangle("fill",0,HUD_BOT_Y,960,HUD_BOT_H)
    love.graphics.setColor(0.13,0.15,0.20) love.graphics.rectangle("fill",0,HUD_BOT_Y,960,HUD_BOT_H/2)
    love.graphics.setColor(0.28,0.48,0.80,0.50) love.graphics.rectangle("fill",0,HUD_BOT_Y,960,2)

    love.graphics.setFont(fontTiny) love.graphics.setColor(0.52,0.54,0.58)
    love.graphics.print("TIENDA",8,HUD_BOT_Y+28)

    local function towerBtn(bx,ttype)
        local def=TOWER_DEFS[ttype]
        local by=HUD_BOT_Y+6 local bw,bh=148,56
        local cols=def.cols[1]
        local isSel=(selectedTType==ttype)
        local canAfford=(gold>=def.cost)

        if isSel then love.graphics.setColor(0.12,0.18,0.32)
        elseif not canAfford then love.graphics.setColor(0.09,0.09,0.11)
        else love.graphics.setColor(0.10,0.13,0.22) end
        love.graphics.rectangle("fill",bx,by,bw,bh,5,5)

        if isSel then
            love.graphics.setColor(cols[3][1],cols[3][2],cols[3][3],0.95)
            love.graphics.setLineWidth(2)
        elseif not canAfford then
            love.graphics.setColor(0.22,0.22,0.28,0.5) love.graphics.setLineWidth(1)
        else
            love.graphics.setColor(cols[2][1]*0.7,cols[2][2]*0.7,cols[2][3]*0.7,0.7)
            love.graphics.setLineWidth(1.5)
        end
        love.graphics.rectangle("line",bx,by,bw,bh,5,5)

        local a=canAfford and 1 or 0.35
        love.graphics.setColor(cols[1][1]*0.55,cols[1][2]*0.55,cols[1][3]*0.55,a)
        love.graphics.circle("fill",bx+28,by+bh/2,14)
        love.graphics.setColor(cols[2][1],cols[2][2],cols[2][3],a)
        love.graphics.circle("fill",bx+28,by+bh/2,10)
        love.graphics.setColor(cols[3][1],cols[3][2],cols[3][3],a)
        love.graphics.circle("fill",bx+28,by+bh/2,5)

        love.graphics.setFont(fontSmall)
        love.graphics.setColor(canAfford and 0.92 or 0.42,
                               canAfford and 0.92 or 0.42,
                               canAfford and 0.96 or 0.48)
        love.graphics.print(def.name,bx+48,by+8)

        love.graphics.setColor(canAfford and 0.15 or 0.12,
                               canAfford and 0.12 or 0.10,
                               0.04)
        love.graphics.rectangle("fill",bx+48,by+32,88,18,3,3)
        love.graphics.setFont(fontTiny)
        love.graphics.setColor(canAfford and 0.98 or 0.55,
                               canAfford and 0.82 or 0.38,
                               canAfford and 0.15 or 0.18)
        love.graphics.print(def.cost.." ORO",bx+52,by+35)

        if isSel then
            love.graphics.setColor(cols[3][1],cols[3][2],cols[3][3],0.45)
            love.graphics.rectangle("fill",bx,by+bh-10,bw,10,0,0,5,5)
            love.graphics.setFont(fontTiny) love.graphics.setColor(1,1,1,0.85)
            love.graphics.print("SELECCIONADA",bx+24,by+bh-9)
        end
    end

    towerBtn(66,"basic") towerBtn(226,"archer") towerBtn(386,"magic")

    -- Right info panel
    love.graphics.setColor(0.18,0.20,0.26) love.graphics.rectangle("fill",548,HUD_BOT_Y+6,402,56,5,5)
    love.graphics.setColor(0.25,0.28,0.36) love.graphics.setLineWidth(1)
    love.graphics.rectangle("line",548,HUD_BOT_Y+6,402,56,5,5)
    love.graphics.setFont(fontSmall) love.graphics.setColor(0.70,0.72,0.78)
    if selectedTower then
        love.graphics.print("Torre seleccionada: usa el panel encima",558,HUD_BOT_Y+12)
        love.graphics.print("de ella para MEJORAR o VENDER.",558,HUD_BOT_Y+30)
    else
        love.graphics.print("Selecciona un tipo de torre y haz click",558,HUD_BOT_Y+12)
        love.graphics.print("en un slot amarillo del mapa para construir.",558,HUD_BOT_Y+30)
    end
    love.graphics.setFont(fontTiny) love.graphics.setColor(0.40,0.42,0.50)
    love.graphics.print("Vender devuelve el 50% del oro invertido.",558,HUD_BOT_Y+48)
end

local function drawTowerPopup()
    if not selectedTower then return end
    local t=selectedTower
    local def=TOWER_DEFS[t.towerType]
    local cols=def.cols[t.level]
    local maxLv=#def.ups
    local isMax=(t.level>=maxLv)
    local px,py,pw,ph=popupRect(t)

    -- Panel bg + border
    love.graphics.setColor(0.06,0.08,0.13,0.97)
    love.graphics.rectangle("fill",px,py,pw,ph,8,8)
    love.graphics.setColor(cols[2][1],cols[2][2],cols[2][3],0.80)
    love.graphics.setLineWidth(2) love.graphics.rectangle("line",px,py,pw,ph,8,8)

    -- Mini tower icon
    love.graphics.setColor(cols[1][1]*0.55,cols[1][2]*0.55,cols[1][3]*0.55)
    love.graphics.circle("fill",px+19,py+23,13)
    love.graphics.setColor(cols[2][1],cols[2][2],cols[2][3])
    love.graphics.circle("fill",px+19,py+23,10)
    love.graphics.setColor(cols[3][1],cols[3][2],cols[3][3])
    love.graphics.circle("fill",px+19,py+23,5)

    -- Name
    love.graphics.setFont(fontSmall) love.graphics.setColor(0.92,0.92,0.96)
    love.graphics.print(def.name,px+37,py+8)

    -- Level dots
    for k=1,maxLv do
        local lx=px+37+(k-1)*13 local ly=py+29
        if k<=t.level then love.graphics.setColor(cols[3][1],cols[3][2],cols[3][3])
        else love.graphics.setColor(0.24,0.24,0.30) end
        love.graphics.circle("fill",lx+4,ly,4.5)
    end

    -- Stats
    love.graphics.setFont(fontTiny) love.graphics.setColor(0.60,0.64,0.72)
    love.graphics.print(
        "DMG "..t.damage.."   RNG "..t.range.."   ATK "..string.format("%.2f",t.attackSpeed).."s",
        px+8,py+46)

    -- Upgrade button (px+8, py+64, 100x24)
    local ubx,uby,ubw,ubh=px+8,py+64,104,22
    if isMax then
        love.graphics.setColor(0.14,0.14,0.18)
        love.graphics.rectangle("fill",ubx,uby,ubw,ubh,4,4)
        love.graphics.setColor(0.32,0.32,0.40) love.graphics.setLineWidth(1)
        love.graphics.rectangle("line",ubx,uby,ubw,ubh,4,4)
        love.graphics.setFont(fontTiny) love.graphics.setColor(0.42,0.42,0.52)
        love.graphics.print("NIVEL MAX",ubx+15,uby+6)
    else
        local nc=def.ups[t.level+1].cost
        local ok=(gold>=nc)
        love.graphics.setColor(ok and 0.06 or 0.14, ok and 0.20 or 0.12, ok and 0.08 or 0.06)
        love.graphics.rectangle("fill",ubx,uby,ubw,ubh,4,4)
        love.graphics.setColor(ok and 0.25 or 0.38, ok and 0.72 or 0.32, ok and 0.30 or 0.18)
        love.graphics.setLineWidth(1) love.graphics.rectangle("line",ubx,uby,ubw,ubh,4,4)
        love.graphics.setFont(fontTiny)
        love.graphics.setColor(ok and 0.35 or 0.65, ok and 0.92 or 0.52, ok and 0.40 or 0.22)
        love.graphics.print("MEJORAR  "..nc.."g",ubx+6,uby+6)
    end

    -- Sell button (px+118, py+64, 102x24)
    local sbx,sby,sbw,sbh=px+118,py+64,102,22
    local refund=math.floor(t.totalCost*0.5)
    love.graphics.setColor(0.20,0.07,0.06) love.graphics.rectangle("fill",sbx,sby,sbw,sbh,4,4)
    love.graphics.setColor(0.72,0.22,0.18) love.graphics.setLineWidth(1)
    love.graphics.rectangle("line",sbx,sby,sbw,sbh,4,4)
    love.graphics.setFont(fontTiny) love.graphics.setColor(1,0.52,0.48)
    love.graphics.print("VENDER  "..refund.."g",sbx+8,sby+6)
end

-- ============================================================
-- OVERLAY HELPERS
-- ============================================================
local function drawWaveAnnounce()
    if waveAnnounceTimer<=0 then return end
    local alpha
    if waveAnnounceTimer>2.3 then alpha=(2.8-waveAnnounceTimer)/0.5
    elseif waveAnnounceTimer<0.8 then alpha=waveAnnounceTimer/0.8
    else alpha=1 end
    alpha=math.max(0,math.min(1,alpha))
    local cy=(HUD_TOP+HUD_BOT_Y)/2
    love.graphics.setColor(0,0,0,0.62*alpha)
    love.graphics.rectangle("fill",220,cy-58,520,116,12,12)
    love.graphics.setColor(0.28,0.48,0.88,0.70*alpha) love.graphics.setLineWidth(2)
    love.graphics.rectangle("line",220,cy-58,520,116,12,12)
    love.graphics.setFont(fontHuge) love.graphics.setColor(1,1,1,alpha)
    local tw=fontHuge:getWidth(waveAnnounceText)
    love.graphics.print(waveAnnounceText,(960-tw)/2,cy-46)
    love.graphics.setFont(fontSmall)
    local sub=currentWave==TOTAL_WAVES and "Ultima oleada!" or "Preparate!"
    love.graphics.setColor(0.60,0.72,1,alpha*0.85)
    local sw=fontSmall:getWidth(sub)
    love.graphics.print(sub,(960-sw)/2,cy+22)
end

local function drawWaveBonus()
    if bonusTimer<=0 then return end
    local alpha=math.min(1,bonusTimer*0.9)
    local cy=(HUD_TOP+HUD_BOT_Y)/2-30
    love.graphics.setFont(fontLarge)
    love.graphics.setColor(0,0,0,alpha*0.5) love.graphics.print("+ "..waveBonus.." ORO",370,cy+2)
    love.graphics.setColor(1,0.88,0.10,alpha) love.graphics.print("+ "..waveBonus.." ORO",368,cy)
    love.graphics.setFont(fontSmall) love.graphics.setColor(0.6,1,0.6,alpha*0.9)
    local sub="Oleada "..currentWave.." completada!"
    local sw=fontSmall:getWidth(sub)
    love.graphics.print(sub,(960-sw)/2,cy+28)
end

local function drawOverlay()
    if waveState~="gameover" and waveState~="victory" then return end
    love.graphics.setColor(0,0,0,0.78) love.graphics.rectangle("fill",0,0,960,540)
    local cy=270
    love.graphics.setColor(0.08,0.10,0.14) love.graphics.rectangle("fill",220,cy-100,520,200,14,14)
    if waveState=="gameover" then
        love.graphics.setColor(0.72,0.08,0.06) love.graphics.rectangle("fill",220,cy-100,520,4,14,14)
        love.graphics.setFont(fontHuge) love.graphics.setColor(0.95,0.18,0.12)
        local tw=fontHuge:getWidth("GAME OVER")
        love.graphics.print("GAME OVER",(960-tw)/2,cy-82)
        love.graphics.setFont(fontMedium) love.graphics.setColor(0.70,0.70,0.75)
        local msg="La base fue destruida en la oleada "..currentWave.."."
        love.graphics.print(msg,(960-fontMedium:getWidth(msg))/2,cy-14)
    else
        love.graphics.setColor(0.75,0.65,0.08) love.graphics.rectangle("fill",220,cy-100,520,4,14,14)
        love.graphics.setFont(fontHuge) love.graphics.setColor(0.98,0.88,0.12)
        local tw=fontHuge:getWidth("VICTORIA!")
        love.graphics.print("VICTORIA!",(960-tw)/2,cy-82)
        love.graphics.setFont(fontMedium) love.graphics.setColor(0.50,0.95,0.55)
        local msg="Has sobrevivido las "..TOTAL_WAVES.." oleadas."
        love.graphics.print(msg,(960-fontMedium:getWidth(msg))/2,cy-14)
    end
    love.graphics.setFont(fontSmall) love.graphics.setColor(0.98,0.82,0.15)
    local gs="Oro final: "..gold
    love.graphics.print(gs,(960-fontSmall:getWidth(gs))/2,cy+22)
    love.graphics.setFont(fontTiny) love.graphics.setColor(0.38,0.40,0.48)
    local hint="Pulsa  R  para reiniciar"
    love.graphics.print(hint,(960-fontTiny:getWidth(hint))/2,cy+66)
end

-- ============================================================
-- MAIN DRAW
-- ============================================================
function love.draw()
    drawPath() drawDecorations() drawBase() drawSlots()
    drawTowers() drawEnemies()
    drawTopBar() drawBottomBar()
    drawTowerPopup()
    drawWaveAnnounce() drawWaveBonus() drawOverlay()
end

-- ============================================================
-- INPUT
-- ============================================================
function love.mousepressed(x,y,button)
    if button~=1 then return end
    if waveState=="gameover" or waveState=="victory" then return end

    -- Bottom bar: select tower type to build
    if y>=HUD_BOT_Y then
        local btns={{type="basic",bx=66},{type="archer",bx=226},{type="magic",bx=386}}
        for _,b in ipairs(btns) do
            if x>=b.bx and x<=b.bx+148 and y>=HUD_BOT_Y+6 and y<=HUD_BOT_Y+62 then
                selectedTType=b.type
                return
            end
        end
        return
    end

    -- Top bar: ignore
    if y<HUD_TOP then return end

    -- Popup buttons (upgrade / sell)
    if selectedTower then
        local px,py,pw,ph=popupRect(selectedTower)
        -- Upgrade: px+8, py+64, 104x22
        if x>=px+8 and x<=px+112 and y>=py+64 and y<=py+86 then
            upgradeTower(selectedTower) return
        end
        -- Sell: px+118, py+64, 102x22
        if x>=px+118 and x<=px+220 and y>=py+64 and y<=py+86 then
            sellTower(selectedTower) return
        end
    end

    -- Click on a tower: select / deselect
    for _,t in ipairs(towers) do
        local r0=18+(t.level-1)*1.5
        if dist(x,y,t.x,t.y)<=r0+5 then
            selectedTower=(selectedTower==t) and nil or t
            return
        end
    end

    -- Click on an empty slot: build selected tower type
    for _,slot in ipairs(slots) do
        local cx=slot.x+slot.size/2 local cy=slot.y+slot.size/2
        if not slot.occupied and dist(x,y,cx,cy)<=slot.size/2+2 then
            local def=TOWER_DEFS[selectedTType]
            if gold>=def.cost then
                gold=gold-def.cost
                slot.occupied=true
                local lv=def.ups[1]
                table.insert(towers,{
                    x=cx,y=cy,
                    towerType=selectedTType,level=1,
                    damage=lv.damage,range=lv.range,
                    attackSpeed=lv.atkSpeed,cooldown=0,
                    totalCost=def.cost,slot=slot,
                })
            end
            return
        end
    end

    -- Click on empty space: deselect tower
    selectedTower=nil
end

function love.keypressed(key)
    if key=="r" and (waveState=="gameover" or waveState=="victory") then
        resetGame()
    end
    if key=="escape" then selectedTower=nil end
end
