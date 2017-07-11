local function makeObj(x, y, w, h, tilename)
   return {
      facing = "right",
      state = "normal",
      remove = false,
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

return makeObj
