local M = {}
local makeObj = require("src.makeObj")

function M.makeArrow(x, y, facing)
   local arrow = makeObj(x, y, 13, 3, "arrow")
   if facing == "right" then
     arrow.vx = 13
   else
     arrow.vx = -13
   end

   arrow.grav = 0.2
   arrow.life = 100
   arrow.vy = -2

   arrow.facing = facing
   return arrow
 end


return M
