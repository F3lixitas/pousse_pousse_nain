extends Node2D

var nodes = Array()
var maxX = 25
var maxY = 15

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		var cursorPos = get_viewport().get_mouse_position()
		var minDist = 10000
		var dist
		var index = 0
		for i in range(0, maxX * maxY):
			dist = cursorPos.distance_to(nodes[i].position)
			if dist < minDist:
				minDist = dist
				index = i
		get_child(maxX * maxY).position = nodes[index].position # le pion est ajouté après les points

func _init():
	#var st = SurfaceTool.new()
	#st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	
	for i in range(0, maxX * maxY):
		var inst = Sprite.new()
		inst.position.x = (i % maxX) * 64 + ((int(i / maxX) % 2) * 32) + 40
		inst.position.y = int(i / maxX) * 55 + 40
		var texture = load("res://images/noeud.png")
		inst.set_scale(Vector2(0.1, 0.1))
		inst.texture = texture
		nodes.append(inst)
		add_child(inst)
	pass
