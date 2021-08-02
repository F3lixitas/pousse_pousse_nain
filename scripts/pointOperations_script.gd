extends Node


static func getPointIndex(maxX, maxY, stepX, stepY, padding, cursorPosition):
	cursorPosition.x -= padding
	cursorPosition.y -= padding
	
	if cursorPosition.x < 0:
		cursorPosition.x = 0
	if cursorPosition.y < 0:
		cursorPosition.y = 0
		
	var y = int(round(cursorPosition.y / stepY))
	var x = int(round((cursorPosition.x - ((y % 2) * stepX / 2)) / stepX))
	
	if y >= maxY:
		y = maxY - 1
	if x >= maxX:
		x = maxX - 1
	
	var out = int(y * maxX + x)
	
	return out



static func getPointPosition(maxX, maxY, stepX, stepY, padding, index):
	var y = int(index / maxX)
	var x = int(index % maxX)
	
	var out = Vector2(padding + x * stepX + (y % 2) * (stepX / 2), padding + y * stepY)
	
	return out

static func getPositionFromCursor(maxX, maxY, stepX, stepY, padding, cursorPosition):
	return getPointPosition(maxX, maxY, stepX, stepY, padding, getPointIndex(maxX, maxY, stepX, stepY, padding, cursorPosition))
