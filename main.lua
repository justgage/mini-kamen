local _ = require("moses")
local theGame = require("theGame")

game = theGame.init()

local tilemap
local frameNum = 0
local winWidth = 32*7
local winHeight = 32*5

love.window.setMode(winWidth, winHeight)
love.window.setTitle("Mini Kamen");

love.graphics.setBackgroundColor( 64, 172, 234 ) -- nice blue

-- this will turn an image into a sprite sheet
-- note that this only works for horizontal sprites
-- also asumes that it one image per animation
function makeAnimation(path, tilew, tileh) 
  img = love.graphics.newImage(path)
  tilew = tilew or 32
  tileh = tileh or 32

  tileNum = img:getWidth() / tilew

  quads = {}

  for i=1, tileNum do
    quads[i] = love.graphics.newQuad((i-1)*tilew, 0, tilew, tileh, img:getDimensions())
  end

  return {
    img = img,
    numFrames = tileNum,
    frames = quads,
    tilew = tilew,
    tileh = tileh,
  }

end

-- this will draw an "animation" (see above function)
function drawAnimation(ani, frameNum, x, y, facing)
  i = math.floor(math.fmod(frameNum, #ani.frames) + 1)

  local halfw = ani.tilew/2
  local halfh =  ani.tileh/2
  local frame =  ani.frames[i]
  local rot = 0
  local xflip = facing == "left" and -1 or 1 -- ternary operator
  local yflip = 1

  love.graphics.draw(
    ani.img, -- image
    frame,   -- frame (quad) we want to draw
    x, y, -- position with with offsets for origin
    rot, -- rotation 
    xflip, yflip, -- fliping (actually scaling)
    halfw, halfh) -- origin
end




-- loads all the images (called once at the begining)
function love.load()

   tilemap = {
      kamen_stand = makeAnimation("kamen.png");
      solids_block = love.graphics.newImage("block.png"),
   }

    love.graphics.newQuad(0, 0, 32, 32, img:getDimensions())
end




-- called very often, dt is the time difference between the last frame and now
function love.update(dt)
  theGame.keyboard(game, love.keyboard);

  -- apply main game logic to players
  for _,p in pairs(game.players) do
    theGame.applyGravity(p)
    theGame.applyFriction(p, game.solids)
    theGame.limitSpeed(p) -- TODO not working?
    theGame.collideMove(p, game.solids);
  end

  frameNum = frameNum + dt*15
end





-- touch controls for mobile
function love.touchmoved(id, x, y, dx, dy, pressure)
  local kamen = game.players.kamen

  kamen.vx = kamen.vx + dx
  kamen.vy = kamen.vy + dy
end




function love.draw()
  love.graphics.push() -- begin camera transformation
  --love.graphics.rotate(rot) -- rotates camera (crazy!)
  -- love.graphics.scale(2, 2) -- zoom in (caused ugly pixels)

  -- camera!
  camx = -game.players.kamen.x + (winWidth)/2
  camy = -game.players.kamen.y + (winHeight)/2
  love.graphics.translate(camx, camy)

  -- draw players
  for _,p in pairs(game.players) do

    -- love.graphics.rectangle("line", p.x, p.y, p.w, p.h ) -- collsion box debuging
    --
    drawAnimation(tilemap[p.img],
                  frameNum, 
                  p.x+p.w/2,
                  p.y+p.h/2, 
                  p.facing);
  end

  -- draw solids
  for _,s in pairs(game.solids) do
    love.graphics.draw(tilemap[s.img], s.x, s.y);
  end

  love.graphics.pop() -- end camera transformation
end
