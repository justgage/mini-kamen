local M = {}

local function makeObj(x, y, w, h, tilename) 
   return {
      x = x,
      y = y,
      w = w,
      h = h,
      img = tilename,
   }
end

local function makeSolid(x, y, tilename)
   local obj = makeObj(x, y, 32, 32, tilename)

   obj.solid = true

   return obj
end

-- makes the game object and retuns it
function M.init()
   local kamen = makeObj(0, 0, 32,32, "kamen_stand")

   return {
      tilemap = {},
      solids = {
         makeSolid(0,0, "solids_block");
      },
      players = {
         kamen = kamen
      }
   }
end



function M.checkCollision(a, b)
   return a.x < b.x + b.w and
          a.y < b.y + b.h and
          b.x < a.x + a.w and
          b.y < a.y + a.h
end

function M.keyboard(gameobj, keyboard) 
   local kamen = gameobj.players.kamen

   if keyboard.isDown("left") then
      kamen.x = kamen.x - 2;
   end

   if keyboard.isDown("right") then
      kamen.x = kamen.x + 2;
   end

   gameobj.players.kamen = kamen

end



return M
