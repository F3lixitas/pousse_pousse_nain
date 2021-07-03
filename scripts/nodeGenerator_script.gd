extends Node2D

var triangles = Array()
var nodes = Array()
var maxX = 24
var maxY = 13

var Noeud = {
	"tri": Array(),
	"pos": Vector2()
}

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		var cursorPos = get_viewport().get_mouse_position()
		var minDist = 10000
		var dist
		var index = 0
		for i in range(0, maxX * maxY):
			dist = cursorPos.distance_to(nodes[i].pos)
			if dist < minDist:
				minDist = dist
				index = i
		get_child((maxX + 1) * maxY * 2 + maxX * 2).position = nodes[index].pos # le pion est ajouté après les points
		pass
		get_child(nodes[index].tri[0]).visible = false
		get_child(nodes[index].tri[1]).visible = false
		get_child(nodes[index].tri[2]).visible = false
		get_child(nodes[index].tri[3]).visible = false
		get_child(nodes[index].tri[4]).visible = false
		get_child(nodes[index].tri[5]).visible = false
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_RIGHT:
		for i in range(0, maxX * maxY):
			get_child(nodes[i].tri[0]).visible = true
			get_child(nodes[i].tri[1]).visible = true
			get_child(nodes[i].tri[2]).visible = true
			get_child(nodes[i].tri[3]).visible = true
			get_child(nodes[i].tri[4]).visible = true
			get_child(nodes[i].tri[5]).visible = true

func _init():
	for i in range(0, maxX * maxY):
		var p = Noeud.duplicate()
		p.pos.x = (i % maxX) * 64 + ((int(i / maxX) % 2) * 32) + 100
		p.pos.y = int(i / maxX) * 55 + 100
		p.tri = [0, 0, 0, 0, 0, 0]
		nodes.append(p)
	
	for i in range(0, (maxX + 1) * maxY):
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		var tempM = Mesh.new()
		var px = (i % (maxX + 1)) * 64 + ((int(i / (maxX + 1)) % 2) * 32) + 36
		var py = int(i / (maxX + 1)) * 55 + 100
		st.add_vertex(Vector3(px + 5, py + 2, 0))
		st.add_vertex(Vector3(px + 59, py + 2, 0))
		st.add_vertex(Vector3(px + 32, py + 53, 0))
		st.commit(tempM)
		var meshI = MeshInstance2D.new()
		meshI.mesh = tempM
		triangles.append(meshI)
		add_child(meshI)
		
		var x = i % (maxX + 1)
		var y = int(i / (maxX + 1))
		
		if not (x == maxX):
			nodes[i - y].tri[0] = i
		if not (x == 0):
			nodes[i - y - 1].tri[4] = i
		if (not (x == 0)) and (y % 2 == 0) and (not (y == maxY - 1)):
			nodes[i - y - 1 + maxX].tri[2] = i
		elif (not (x == maxX)) and (y % 2 == 1) and (not (y == maxY - 1)):
			nodes[i - y + maxX].tri[2] = i
	
	for i in range(0, (maxX + 1) * maxY):
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		var tempM = Mesh.new()
		var px = (i % (maxX + 1)) * 64 + ((int(i / (maxX + 1)) % 2) * 32) + 36
		var py = int(i / (maxX + 1)) * 55 + 100
		st.add_vertex(Vector3(px + 5, py - 2, 0))
		st.add_vertex(Vector3(px + 59, py - 2, 0))
		st.add_vertex(Vector3(px + 32, py - 53, 0))
		st.commit(tempM)
		var meshI = MeshInstance2D.new()
		meshI.mesh = tempM
		triangles.append(meshI)
		add_child(meshI)
		
		var x = i % (maxX + 1)
		var y = int(i / (maxX + 1))
		
		var index = i + (maxX + 1) * maxY
		
		if not (x == maxX):
			nodes[i - y].tri[1] = index
		if not (x == 0):
			nodes[i - y - 1].tri[3] = index
		if (not (x == 0)) and (y % 2 == 0) and (not (y == 0)):
			nodes[i - y - 1 - maxX].tri[5] = index
		elif (not (x == maxX)) and (y % 2 == 1) and (not (y == 0)):
			nodes[i - y - maxX].tri[5] = index
	
	for i in range(0, maxX):
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		var tempM = Mesh.new()
		var px = (i % maxX) * 64 + 100
		var py = 100
		st.add_vertex(Vector3(px, py - 2, 0))
		st.add_vertex(Vector3(px - 27, py - 53, 0))
		st.add_vertex(Vector3(px + 27, py - 53, 0))
		st.commit(tempM)
		var meshI = MeshInstance2D.new()
		meshI.mesh = tempM
		triangles.append(meshI)
		add_child(meshI)
		
		var index = i + (maxX + 1) * maxY * 2
		nodes[i].tri[2] = index
	
	for i in range(0, maxX):
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		var tempM = Mesh.new()
		var px = (i % maxX) * 64 + 100 + (((maxY + 1) % 2) * 32)
		var py = 100 + (maxY - 1) * 55
		st.add_vertex(Vector3(px, py + 2, 0))
		st.add_vertex(Vector3(px - 27, py + 53, 0))
		st.add_vertex(Vector3(px + 27, py + 53, 0))
		st.commit(tempM)
		var meshI = MeshInstance2D.new()
		meshI.mesh = tempM
		triangles.append(meshI)
		add_child(meshI)
		
		var index = i + (maxX + 1) * maxY * 2 + maxX
		nodes[maxX * (maxY - 1) + i].tri[5] = index
