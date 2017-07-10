local M = {}

-- this will turn an image into a sprite sheet
-- note that this only works for horizontal sprites
-- also asumes that it one image per animation
function M.new(path, tilew, tileh)
  img = love.graphics.newImage(path)
  size = img:getHeight()
  tilew = tilew or size
  tileh = tileh or size

  tileNum = img:getWidth() / tilew

  quads = {}

  -- make a quad for each frame of the animaiton
  -- perhaps not the fastest but it's simple
  for i=1, tileNum do
    quads[i] = love.graphics.newQuad(
      (i-1)*tilew,
      0,
      tilew,
      tileh,
      img:getDimensions()
    )
  end

  return {
    img = img,
    numFrames = tileNum,
    frames = quads,
    tilew = tilew,
    tileh = tileh,
  }
end

-- this will draw an "animation" (see above function)
function M.draw(ani, frameNum, x, y, facing)
  i = math.floor(math.fmod(frameNum, #ani.frames) + 1)

  local halfw = ani.tilew/2
  local halfh =  ani.tileh/2
  local frame =  ani.frames[i]
  local rot = 0
  local xflip = facing == "left" and 1 or -1
  local yflip = 1

  love.graphics.draw(
    ani.img, -- image
    frame,   -- frame (quad) we want to draw
    x, y, -- position with with offsets for origin
    rot, -- rotation
    xflip, yflip, -- fliping (actually scaling)
    halfw, halfh) -- origin
end

return M
