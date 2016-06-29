local _ = require("moses")
local theGame = require("theGame")

game = theGame.init()

local tilemap


-------------------------------------------------------

winWidth = 32*20
winHeight = 32*15

love.window.setMode(winWidth, winHeight)
love.window.setTitle("Mini Kamen");

function love.load()
   --love.graphics.setColor(0,0,0)
   tilemap = {
      kamen_stand = love.graphics.newImage("kamen.png"),
      solids_block = love.graphics.newImage("block.png"),
   }
end

function love.update(dt)
  theGame.keyboard(game, love.keyboard);

  for _,p in pairs(game.players) do
    theGame.applyGravity(p)
    theGame.collideMove(p, game.solids);
  end
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
    love.graphics.draw(tilemap[p.img], p.x-p.w/2, p.y-p.h/2);
    love.graphics.rectangle("line", p.x, p.y, p.w, p.h )
  end

  for _,s in pairs(game.solids) do
    love.graphics.draw(tilemap[s.img], s.x, s.y);
  end

  -----
  love.graphics.pop()
end
