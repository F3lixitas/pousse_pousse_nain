extends Node2D

var triangles = Array()
var nodes = Array()
var maxX = 25
var maxY = 15

var Noeud = {
	"tri": Array([0, 0, 0, 0, 0, 0]),
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
		#get_child(maxX * maxY * 2 + maxY * 2).position = nodes[index].pos # le pion est ajouté après les points
		get_child(nodes[index].tri[0]).visible = false

func _init():
	for i in range(0, maxX * maxY):
		var p = Noeud.duplicate()
		p.pos.x = (i % maxX) * 64 + ((int(i / maxX) % 2) * 32) + 100
		p.pos.y = int(i / maxX) * 55 + 100
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
		if (not (i % (maxX + 1) == 0) or i == 0):
			nodes[i - int(i / maxX)].tri[0] = i
	
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
	
	pass
