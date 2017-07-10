local M = {}
local Collision = require('src.collision');

function M.keyboard(player, gameobj, keyboard)
   player.next_y = player.y + 1 -- FIXME remove next_x/next_y
   if keyboard.isDown(player.keys.down) then
      player.vy = player.vy + 3;
   elseif keyboard.isDown(player.keys.up)
      and Collision.collidesWithAny(player, gameobj.solids)
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
