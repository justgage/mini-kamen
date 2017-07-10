local M = {}

function M.collidesWith(a, b)
   return (a.next_x < b.x + b.w and
          a.next_y < b.y + b.h and
          b.x < a.next_x + a.w and
          b.y < a.next_y + a.h)
end

function M.collidesWithAny(obj, solids)
   for _,s in pairs(solids) do
      if M.collidesWith(obj, s) then
         return true
      end
   end

   return false
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

function M.collideMove(obj,solids)
   byX = sign(obj.vx)
   byY = sign(obj.vy)

   obj.next_x = obj.x
   obj.next_y = obj.y

   -- move in the x direction slowly
   for i=1, math.abs(obj.vx),1 do
      obj.next_x = obj.next_x + byX

      if M.collidesWithAny(obj, solids) then
         obj.vx = 0
         break
      end

      obj.x = obj.next_x
   end

   obj.next_x = obj.x

   -- move in the y direction slowly
   for i=1, math.abs(obj.vy),1 do
      obj.next_y = obj.next_y + byY

      if M.collidesWithAny(obj, solids) then
         obj.vy = 0
         break
      end

      obj.y = obj.next_y
   end

   obj.next_y = obj.x
end

return M
