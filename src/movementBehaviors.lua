local M = {}
local Collision = require("src.collision")

--------------------------------------------------
-- makes sure the object doesn't go beyond it's
-- max velocity in x and y direction
--------------------------------------------------
function M.limitSpeed(gameobj)
   gameobj.vx = math.min(gameobj.vx,  gameobj.maxv)
   gameobj.vx = math.max(gameobj.vx, -gameobj.maxv)

   gameobj.vy = math.min(gameobj.vy,  gameobj.maxv*3)
   gameobj.vy = math.max(gameobj.vy, -gameobj.maxv*3)
end

------------------------------------------------
-- If there's a solid below the object
-- then apply friction based on that solids's
-- friction
------------------------------------------------
function M.applyFriction(obj, solids)
   if not obj.moving then
      local frict = 1 -- assume no friction

      for _,s in pairs(solids) do
         obj.next_y = obj.y + 1
         obj.next_x = obj.x
         if Collision.collidesWith(obj, s) then
            frict = s.frict
         end
      end

      obj.vx = obj.vx * frict
   end
end

function M.applyGravity(obj)
   obj.vy = obj.vy + obj.grav
end

return M
