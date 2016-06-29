local M = {}

local function makeObj(x, y, w, h, tilename) 
   return {
      x = x,
      vx = 0,
      y = y,
      vy = 0,
      w = w,
      h = h,
      img = tilename,
      touch_bottom = false,
   }
end

local function makeSolid(x, y, tilename)
   local obj = makeObj(x, y, 32, 32, tilename)

   obj.solid = true

   return obj
end


-- makes the game object and retuns it
function M.init()
   local kamen = makeObj(64, 64, 32,32, "kamen_stand")
   kamen.grav = 0.6

   return {
      tilemap = {},
      solids = {
         makeSolid(32*(7 + 1) , 13*32 - 0  , "solids_block") ,
         makeSolid(32*(7 + 2) , 13*32 - 0  , "solids_block") ,
         makeSolid(32*(7 + 3) , 13*32 - 0  , "solids_block") ,
         makeSolid(32*(7 + 4) , 13*32 - 0  , "solids_block") ,
         makeSolid(32*(7 + 5) , 13*32 - 0  , "solids_block") ,
         makeSolid(32*(7 + 6) , 13*32 - 0  , "solids_block") ,
         makeSolid(32*(7 + 6) , 13*32 - 32 , "solids_block") ,
         
         makeSolid(0  , 32*6 , "solids_block") ,
         makeSolid(0  , 32*7 , "solids_block") ,
         makeSolid(0  , 32*8 , "solids_block") ,
         makeSolid(0  , 32*9 , "solids_block") ,
         makeSolid(0  , 32*10 , "solids_block") ,
         makeSolid(0  , 32*11 , "solids_block") ,

         makeSolid(0    , 14*32 - 32 , "solids_block") ,
         makeSolid(0    , 14*32 - 0  , "solids_block") ,
         makeSolid(32*1 , 14*32 - 0  , "solids_block") ,
         makeSolid(32*2 , 14*32 - 0  , "solids_block") ,
         makeSolid(32*3 , 14*32 - 0  , "solids_block") ,
         makeSolid(32*4 , 14*32 - 0  , "solids_block") ,
         makeSolid(32*5 , 14*32 - 0  , "solids_block") ,
         makeSolid(32*6 , 14*32 - 0  , "solids_block") ,
         makeSolid(32*6 , 14*32 - 32 , "solids_block") ,

      },
      players = {
         kamen = kamen
      }
   }
end


local function sign(x)
   if x<0 then
     return -1
   elseif x>0 then
     return 1
   else
     return 0
   end
end

local function collidesWith(a, b)
   return (a.next_x < b.x + b.w and
          a.next_y < b.y + b.h and
          b.x < a.next_x + a.w and
          b.y < a.next_y + a.h)
end

function M.applyGravity(obj) 
   obj.vy = obj.vy + obj.grav
end

function collidesWithAny(obj, solids)
   for _,s in pairs(solids) do
      if collidesWith(obj, s) then
         return true
      end
   end

   return false
end


function M.collideMove(obj,solids) 
   byX = sign(obj.vx)
   byY = sign(obj.vy)

   obj.next_x = obj.x
   obj.next_y = obj.y

   -- move in the x direction slowly
   for i=1, math.abs(obj.vx),1 do
      obj.next_x = obj.next_x + byX

      if collidesWithAny(obj, solids) then
         obj.vx = 0
         break
      end

      obj.x = obj.next_x
   end

   obj.next_x = obj.x

   -- move in the y direction slowly
   for i=1, math.abs(obj.vy),1 do
      obj.next_y = obj.next_y + byY

      if collidesWithAny(obj, solids) then
         obj.vy = 0
         break
      end

      obj.y = obj.next_y
   end

   obj.next_y = obj.x

end

function M.keyboard(gameobj, keyboard) 
   local kamen = gameobj.players.kamen

   kamen.next_y = kamen.y + 1 -- FIXME remove next_x/next_y
   if keyboard.isDown("up") 
      and collidesWithAny(kamen, gameobj.solids) 
      then
      kamen.vy = kamen.vy - 10;
   end

   if keyboard.isDown("down") then
      kamen.vy = kamen.vy + 3;
   end

   if keyboard.isDown("left") then
      kamen.vx = kamen.vx - 1;
   end
   if keyboard.isDown("right") then
      kamen.vx = kamen.vx + 1;
   end

   gameobj.players.kamen = kamen

end

function M.limitSpeed(gameobjs)
   for _,val in pairs(gameobjs) do
      -- limit speed
   end
end


return M
