local M = {}

local function makeObj(x, y, w, h, tilename) 
   return {
      facing = "right",
      moving = false,
      x = x,
      vx = 0,
      y = y,
      vy = 0,
      maxv = 5,
      w = w,
      h = h,
      img = tilename,
      touch_bottom = false,
   }
end

local function makeSolid(x, y, tilename)
   local obj = makeObj(x, y, 24, 24, tilename)

   obj.solid = true
   obj.frict = 0.8

   return obj
end


-- makes the game object and retuns it
function M.init(map)
   local gage = makeObj(64, 64, 24, 24, "gage_stand")
   gage.grav = 0.6

   gage.keys = {
      up = "up",
      down = "down",
      left = "left",
      right = "right",
   };


   local solids = {}


   for y, row in pairs(map.layers["Foreground"].data) do
      for x, tile in pairs(row) do
         solids[#solids+1] = makeSolid(24*( x-1 ), 24*( y-1  ), "solids_block")
      end
   end

   return {
      tilemap = {},
      solids = solids,
      players = {
         gage = gage
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

function M.applyFriction(obj, solids) 
   if not obj.moving then
      local frict = 1 -- assume no friction

      for _,s in pairs(solids) do
         obj.next_y = obj.y + 1
         obj.next_x = obj.x
         if collidesWith(obj, s) then
            frict = s.frict
         end
      end

      obj.vx = obj.vx * frict
   end
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

function M.limitSpeed(gameobj)
   gameobj.vx = math.min(gameobj.vx,  gameobj.maxv)
   gameobj.vx = math.max(gameobj.vx, -gameobj.maxv)

   gameobj.vy = math.min(gameobj.vy,  gameobj.maxv*3)
   gameobj.vy = math.max(gameobj.vy, -gameobj.maxv*3)
end


function M.keyboard(player, gameobj, keyboard) 
   player.next_y = player.y + 1 -- FIXME remove next_x/next_y
   if keyboard.isDown(player.keys.down) then
      player.vy = player.vy + 3;
   elseif keyboard.isDown(player.keys.up) 
      and collidesWithAny(player, gameobj.solids) 
      then
      player.vy = player.vy - 10;
   end

   if keyboard.isDown(player.keys.left) then
      player.facing = "left"
      player.vx = player.vx - 1;
      player.moving = true
   elseif keyboard.isDown(player.keys.right) then
      player.facing = "right"
      player.vx = player.vx + 1;
      player.moving = true
   else
      player.moving = false
   end
end

return M
