local _ = require("moses")
local theGame = require("theGame")

game = theGame.init()

local tilemap


-------------------------------------------------------

function love.load()
   --love.graphics.setColor(0,0,0)
   --love.graphics.setBackgroundColor(255,255,255)
   tilemap = {
      kamen_stand = love.graphics.newImage("kamen.png"),
      solids_block = love.graphics.newImage("block.png"),
   }
end

function love.update(dt)
  theGame.keyboard(game, love.keyboard);
end

function love.draw()
  for _,p in pairs(game.players) do
    love.graphics.draw(tilemap[p.img], p.x, p.y);
  end

  for _,s in pairs(game.solids) do
    love.graphics.draw(tilemap[s.img], s.x, s.y);
  end
end
