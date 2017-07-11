local M = {}
local makeObj = require("src.makeObj")
local makeSolid = require("src.makeSolid")

----------------------------------------
-- makes the game objects and retuns it
----------------------------------------
function M.init(map)
   local gage = makeObj(64, 64, 24, 24, "gage_stand")
   gage.grav = 0.6

   gage.keys = {
      up = "w",
      down = "s",
      left = "a",
      right = "d",
   };

   local jess = makeObj(64, 24*4, 24, 24, "jess_stand")
   jess.grav = 0.6

   jess.keys = {
      up = "up",
      down = "down",
      left = "left",
      right = "right",
      shoot = "space",
   };


   -- create the map --
   local solids = {}

   for y, row in pairs(map.layers["Foreground"].data) do
      for x, tile in pairs(row) do
         solids[#solids+1] = makeSolid(24*( x-1 ), 24*( y-1  ), "solids_block")
      end
   end


   local bullets = {arrow}

   return {
      tilemap = {},
      solids = solids,
      players = {
         gage = gage,
         jess = jess
      },
      bullets = bullets
   }
end

return M
