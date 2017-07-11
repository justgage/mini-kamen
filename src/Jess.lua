local M = {}
local Bullets = require("src.bullets")

----------------------------------------------------
-- All the game logic of the jess character
----------------------------------------------------
function M.update(jess, bullets)
  if love.keyboard.isDown(jess.keys.shoot) then
    jess.state = "shooting"
  elseif jess.state == "shooting" then
    jess.state = "normal"
    table.insert(bullets, Bullets.makeArrow(jess.x, jess.y+jess.h/2, jess.facing))
  end
end

return M
