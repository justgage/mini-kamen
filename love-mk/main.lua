local _ = require("moses")
local theGame = require("theGame")

game = theGame.init()

local tilemap
local frameNum = 0


-------------------------------------------------------

winWidth = 32*20
winHeight = 32*15

love.window.setMode(winWidth, winHeight)
love.window.setTitle("Mini Kamen");

function makeAnimationImage(path, tilew, tileh) 
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
    x+halfw, y+halfh, -- position with with offsets for origin
    rot, -- rotation 
    xflip, yflip, -- fliping (actually scaling)
    halfw, halfh) -- origin
end

function love.load()

   tilemap = {
      kamen_stand = makeAnimationImage("kamen.png");
      solids_block = love.graphics.newImage("block.png"),
   }

    love.graphics.newQuad(0, 0, 32, 32, img:getDimensions())
end

function love.update(dt)
  theGame.keyboard(game, love.keyboard);

  for _,p in pairs(game.players) do
    theGame.applyGravity(p)
    theGame.collideMove(p, game.solids);
  end

  frameNum = frameNum + dt*15
end

function love.touchmoved(id, x, y, dx, dy, pressure)
  local kamen = game.players.kamen

  kamen.vx = kamen.vx + dx
  kamen.vy = kamen.vy + dy
end

local rot = 0;

function love.draw()
  love.graphics.push()
  rot = rot +  3.12/10
  --love.graphics.rotate(rot)
  love.graphics.scale(2, 2)
  love.graphics.translate(-game.players.kamen.x + (winWidth)/2/2, -game.players.kamen.y + (winHeight)/2/2)
  -------
  for _,p in pairs(game.players) do
    love.graphics.rectangle("line", p.x, p.y, p.w, p.h )
    drawAnimation(tilemap[p.img], frameNum, p.x-p.w/2, p.y-p.h/2, p.facing);
  end

  for _,s in pairs(game.solids) do
    love.graphics.draw(tilemap[s.img], s.x, s.y);
  end

  -----
  love.graphics.pop()
end
