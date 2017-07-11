local M = {}

------------------------------------------------
-- This will remove all the objects that have
-- been marked "dead" by setting "remove"=true
------------------------------------------------
function M.removeDead(objList)
  newList = {}

  for i,obj in ipairs(objList) do
    if obj.remove == false then
      table.insert(newList, obj)
    end
  end

  return newList
end

-----------------------------------------------
-- Lower the life of a object. If it goes below
-- or equal to 0 then it will set it to be
-- removed
-----------------------------------------------
function M.lowerLife(obj, amount)
  obj.life = obj.life or 0
  obj.life = obj.life - amount

  if obj.life <= 0 then
    obj.remove = true
  end
end


return M
