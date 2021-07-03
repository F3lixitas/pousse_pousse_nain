extends Node2D

var nodes = Array()            #tableau des noeuds de notre plateau
var maxX = 24                  #nb de noeuds en X
var maxY = 13                  #nb de noeuds en Y

var stepX = 64                 #modifier pour changer la taille en pixels du plateau, mettre des valeurs paires
var stepY = int(stepX * 0.866) #ne pas modifier, 0.866 est le ratio pour un triangle equilateral

var padding = 100              #définit l'espace entre le plateau et le bord
var lineWidth = 4              #définit la largeur des lignes entre les triangles, mettre des valeurs paires

var Noeud = {
	"tri": Array(),            #tableau des indices des triangles, permet de faciliter le changement de couleur
	"pos": Vector2()           #position du noeud
}

#fonctions de génération
#remplit le tableau de noeuds avec la bonne position
func genererNoeuds():
	for i in range(0, maxX * maxY):
		var p = Noeud.duplicate()
		p.pos.x = (i % maxX) * stepX + ((int(i / maxX) % 2) * int(stepX / 2)) + padding
		p.pos.y = int(i / maxX) * stepY + padding
		p.tri = [0, 0, 0, 0, 0, 0]
		nodes.append(p)

func genererTriangles():
	for i in range(0, (maxX + 1) * maxY):
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		var tempM = Mesh.new()
		var px = (i % (maxX + 1)) * stepX + ((int(i / (maxX + 1)) % 2) * int(stepX / 2)) + (padding - stepX)
		var py = int(i / (maxX + 1)) * stepY + padding
		st.add_vertex(Vector3(px + lineWidth, py + int(lineWidth / 2), 0))
		st.add_vertex(Vector3(px + stepX - lineWidth, py + int(lineWidth / 2), 0))
		st.add_vertex(Vector3(px + int(stepX / 2), py + stepY - lineWidth, 0))
		st.commit(tempM)
		var meshI = MeshInstance2D.new()
		meshI.mesh = tempM
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
		st.add_vertex(Vector3(px + 4, py - 2, 0))
		st.add_vertex(Vector3(px + 60, py - 2, 0))
		st.add_vertex(Vector3(px + 32, py - 51, 0))
		st.commit(tempM)
		var meshI = MeshInstance2D.new()
		meshI.mesh = tempM
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
		st.add_vertex(Vector3(px, py - 4, 0))
		st.add_vertex(Vector3(px - 27, py - 51, 0))
		st.add_vertex(Vector3(px + 27, py - 51, 0))
		st.commit(tempM)
		var meshI = MeshInstance2D.new()
		meshI.mesh = tempM
		add_child(meshI)
		
		var index = i + (maxX + 1) * maxY * 2
		nodes[i].tri[2] = index
	
	for i in range(0, maxX):
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		var tempM = Mesh.new()
		var px = (i % maxX) * 64 + 100 + (((maxY + 1) % 2) * 32)
		var py = 100 + (maxY - 1) * 55
		st.add_vertex(Vector3(px, py + 4, 0))
		st.add_vertex(Vector3(px - 27, py + 51, 0))
		st.add_vertex(Vector3(px + 27, py + 51, 0))
		st.commit(tempM)
		var meshI = MeshInstance2D.new()
		meshI.mesh = tempM
		add_child(meshI)
		
		var index = i + (maxX + 1) * maxY * 2 + maxX
		nodes[maxX * (maxY - 1) + i].tri[5] = index




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
	genererNoeuds()
	genererTriangles()
	
