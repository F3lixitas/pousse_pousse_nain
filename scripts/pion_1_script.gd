extends Sprite


func _process(delta):
	var cursorPos = get_viewport().get_mouse_position()
	position.x = cursorPos.x
	position.y = cursorPos.y
