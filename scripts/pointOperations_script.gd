extends Node

static func constrainMin(value, mini):
	if value < mini:
		return mini
	else:
		return value

static func getPointIndex(maxX, maxY, stepX, stepY, padding, cursorPosition):
	cursorPosition.x -= padding
	cursorPosition.y -= padding
	
	if cursorPosition.x < 0:
		cursorPosition.x = 0
	if cursorPosition.y < 0:
		cursorPosition.y = 0
		
	var y = int(round(cursorPosition.y / stepY))
	var x = int(round(constrainMin((cursorPosition.x - ((y % 2) * stepX / 2)), 0) / stepX))
	
	if y >= maxY:
		y = maxY - 1
	if x >= maxX:
		x = maxX - 1
	
	var out = int(y * maxX + x)
	
	return out



static func getPointPosition(maxX, maxY, stepX, stepY, padding, index):
	var vec = splitXY(maxX, maxY, index)
	
	var out = Vector2(padding + vec.x * stepX + (int(vec.y) % 2) * (stepX / 2), padding + vec.y * stepY)
	
	return out



static func getPositionFromCursor(maxX, maxY, stepX, stepY, padding, cursorPosition):
	return getPointPosition(maxX, maxY, stepX, stepY, padding, getPointIndex(maxX, maxY, stepX, stepY, padding, cursorPosition))



static func splitXY(maxX, maxY, index):
	var y = int(index / maxX)
	var x = int(index % maxX)
	
	var out = Vector2(x, y)
	
	return out



static func checkValidity(index, node):
	if not node.points[index].occupation == 0:
		return false
	for i in range(0, 6):
		if not node.points[index].neighbour[i] < 0:
			if not node.points[node.points[index].neighbour[i]].occupation == 0:
				return false
	return true
