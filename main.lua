-------------------------------
-- Local Libs
-------------------------------
local Level = require("src.level")
local Animation = require("src.animation")
local MovementBehaviors = require("src.movementBehaviors")
local Collision = require("src.collision")
local Player = require("src.player")

-------------------------------
-- libs
-------------------------------
local sti = require("lib.Simple-Tiled-Implementation.sti")

-------------------------------
-- globals
-------------------------------
local tilemap
local frameNum = 0
local winWidth = 24*40
local winHeight = 24*30
local camx=0
local camy=0

local map = sti("assets/data/level1.lua")
map:resize(winWidth, winHeight);

local level = Level.init(map)

love.window.setMode(winWidth, winHeight)
love.window.setTitle("Jess N' Gage");

love.graphics.setBackgroundColor( 64, 64, 64 )


-----------------------------------------
-- loads all the images (called once at
-- the begining)
-----------------------------------------
function love.load()

  tilemap = {
    jess_run = Animation.new("assets/images/jess-run.png");
    jess_stand = Animation.new("assets/images/jess.png");
    gage_stand = Animation.new("assets/images/gage-walk.png");
    solids_block = love.graphics.newImage("assets/images/middle-ground.png"),
  }

  love.graphics.newQuad(0, 0, 24, 24, img:getDimensions())
end


------------------------------------
-- called very often, dt is the
-- time difference between the last
-- frame and now
-----------------------------------
function love.update(dt)

  -- apply main game logic to players
  for _,p in pairs(level.players) do
    Player.keyboard(p, level, love.keyboard);
    MovementBehaviors.applyGravity(p)
    MovementBehaviors.applyFriction(p, level.solids)
    MovementBehaviors.limitSpeed(p)
    Collision.collideMove(p, level.solids);
  end

  frameNum = frameNum + dt*15
  map:update(dt)
end



-------------------------------
-- touch controls for mobile
-------------------------------
function love.touchmoved(id, x, y, dx, dy, pressure)
  local gage = level.players.gage

  if x < camX then
    gage.facing = "left"
    gage.vx = gage.vx - 1;
    gage.moving = true
  elseif x > camX then
    gage.facing = "right"
    gage.vx = gage.vx + 1;
    gage.moving = true
  end

end


-------------------------------
-- Draw
-------------------------------
function love.draw()
  love.graphics.push() -- begin camera transformation

  -- camera!
  gage = level.players.gage
  jess = level.players.jess
  camx = math.floor(-(gage.x + jess.x)/2 + (winWidth)/2)
  camy = math.floor(-(gage.y + jess.y)/2 + (winHeight)/2)
  camx = math.min(0, camx)
  camy = math.min(0, camy)

  love.graphics.translate(camx, camy)

  -- draw players
  for _,p in pairs(level.players) do

    -- collsion box debuging
    -- love.graphics.rectangle("line", p.x, p.y, p.w, p.h )

    -- draw player
    Animation.draw(tilemap[p.img],
                  frameNum,
                  p.x+p.w/2,
                  p.y+p.h/2,
                  p.facing);
  map:drawLayer(map.layers["Foreground"])
  map:drawLayer(map.layers["Background-front"])
  end

  love.graphics.pop() -- end camera transformation
end
