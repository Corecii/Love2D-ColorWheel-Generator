function HSL(h, s, l)
	if s == 0 then return l,l,l end
	h, s, l = h/360*6, math.min(math.max(0, s), 1), math.min(math.max(0, l), 1)
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end
	return math.ceil((r+m)*256),math.ceil((g+m)*256),math.ceil((b+m)*256)
end

local function dist(ax, ay, bx, by)
	return ((bx - ax)^2 + (by - ay)^2)^0.5
end

local function mixColors(...)
	local col = {0, 0, 0, 0}
	local args = {...}
	for i = 1, #args, 5 do
		col[1] = col[1] + args[i + 1]*args[i]
		col[2] = col[2] + args[i + 2]*args[i]
		col[3] = col[3] + args[i + 3]*args[i]
		col[4] = col[4] + args[i + 4]*args[i]
	end
	return col
end

function math.clamp(num, min, max)
	return (num < min and min) or (num > max and max) or num
end

local function relative(rad, ax, ay, bx, by)
	local dx, dy = bx - ax, by - ay
	local distance = dist(ax, ay, bx, by)
	local baseRad = math.atan2(dy, dx)
	local nx = math.cos(baseRad - rad)*distance
	local ny = math.sin(baseRad - rad)*distance
	return nx, ny
end

local function rotate(rad, ax, ay, bx, by)
	local nx, ny = relative(rad, ax, ay, bx, by)
	return ax + nx, ay + ny
end

local startup = true
function love.draw()
	if startup then
		love.graphics.clear(0, 0, 0, 0)
		for x = 0, 1023 do
			for y = 0, 1023 do
				local rot = (math.atan2(y - 511.5, x - 511.5) + math.pi)/(math.pi*2)
				local r, g, b = HSL(rot*360, 1, 0.5)
				love.graphics.setColor(r, g, b)
				love.graphics.rectangle('fill', x, y, 1, 1)
			end
		end
		local screenshot = love.graphics.newScreenshot(true)
		screenshot:encode('png', 'ColorWheel.png')

		love.graphics.clear(0, 0, 0, 0)
		local rightXc, rightYc = 0, 0
		local rightRad = math.rad(-30)
		local leftXc, leftYc = 1023, 0
		local leftRad = math.rad(180 + 30)
		local centerXc, centerYc = math.sin(math.rad(60))*1023, 0
		local centerRad = math.rad(90)
		local maxVal = math.sin(math.rad(60))*1023
		for x = 0, 1023 do
			for y = 0, 1023 do
				local rightX, rightY = relative(rightRad, rightXc,rightYc, x,y)
				local leftX, leftY = relative(leftRad, leftXc,leftYc, x,y)
				local centerX, centerY = relative(centerRad, centerXc,centerYc, x,y)
				local colorAmt = math.clamp(rightX/maxVal, 0, 1)
				local blackAmt = math.clamp(leftX/maxVal, 0, 1)
				local whiteAmt = math.clamp(centerX/maxVal, 0, 1)

				local color = mixColors(colorAmt, 255,0,0,255, whiteAmt, 255,255,255,255, blackAmt, 0,0,0,255)
				love.graphics.setColor(color)
				love.graphics.rectangle('fill', x, y, 1, 1)
			end
		end
		local screenshot = love.graphics.newScreenshot(true)
		screenshot:encode('png', 'SLTriFull.png')

		love.graphics.clear(255, 255, 255, 0)
		for x = 0, 1023 do
			for y = 0, 1023 do
				local rightX, rightY = relative(rightRad, rightXc,rightYc, x,y)
				local leftX, leftY = relative(leftRad, leftXc,leftYc, x,y)
				local centerX, centerY = relative(centerRad, centerXc,centerYc, x,y)
				local colorAmt = math.clamp(rightX/maxVal, 0, 1)
				local blackAmt = math.clamp(leftX/maxVal, 0, 1)
				local whiteAmt = math.clamp(centerX/maxVal, 0, 1)

				local color = mixColors(whiteAmt/(whiteAmt + blackAmt), 255,255,255,255, blackAmt/(whiteAmt + blackAmt), 0,0,0,255)
				love.graphics.setColor(color)
				love.graphics.rectangle('fill', x, y, 1, 1)
			end
		end
		local screenshot = love.graphics.newScreenshot(true)
		screenshot:encode('png', 'SLTriBW.png')

		love.graphics.clear(255, 255, 255, 0)
		for x = 0, 1023 do
			for y = 0, 1023 do
				local rightX, rightY = relative(rightRad, rightXc,rightYc, x,y)
				local leftX, leftY = relative(leftRad, leftXc,leftYc, x,y)
				local centerX, centerY = relative(centerRad, centerXc,centerYc, x,y)
				local colorAmt = math.clamp(rightX/maxVal, 0, 1)
				local blackAmt = math.clamp(leftX/maxVal, 0, 1)
				local whiteAmt = math.clamp(centerX/maxVal, 0, 1)

				local color = mixColors(colorAmt, 255,255,255,255, 1 - colorAmt, 255,255,255,0)
				love.graphics.setColor(color)
				love.graphics.rectangle('fill', x, y, 1, 1)
			end
		end
		local screenshot = love.graphics.newScreenshot(true)
		screenshot:encode('png', 'SLTriColor.png')

		love.graphics.clear(255, 0, 0, 0)
		for x = 0, 1023 do
			for y = 0, 1023 do
				local rightX, rightY = relative(rightRad, rightXc,rightYc, x,y)
				local leftX, leftY = relative(leftRad, leftXc,leftYc, x,y)
				local centerX, centerY = relative(centerRad, centerXc,centerYc, x,y)
				local colorAmt = math.clamp(rightX/maxVal, 0, 1)
				local blackAmt = math.clamp(leftX/maxVal, 0, 1)
				local whiteAmt = math.clamp(centerX/maxVal, 0, 1)

				local color = mixColors(colorAmt, 255,0,0,255, 1 - colorAmt, 255,0,0,0)
				love.graphics.setColor(color)
				love.graphics.rectangle('fill', x, y, 1, 1)
			end
		end
		local screenshot = love.graphics.newScreenshot(true)
		screenshot:encode('png', 'SLTriColorTest.png')
	end

	startup = false
	love.event.quit()
end