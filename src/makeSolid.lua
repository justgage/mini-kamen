local makeObj = require("src.makeObj")

local function makeSolid(x, y, tilename)
   local obj = makeObj(x, y, 24, 24, tilename)

   obj.solid = true
   obj.frict = 0.8

   return obj
end

return makeSolid
