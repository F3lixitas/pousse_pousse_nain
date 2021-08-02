extends OptionButton

func _init():
	add_item("1920 x 1080", 0)
	add_item("1440 x 900", 1)
	add_item("1280 x 720", 2)


func _on_OptionButton_item_selected(index):
	if index == 0:
		OS.window_size = Vector2(1920, 1080)
	elif index == 1:
		OS.window_size = Vector2(1440, 900)
	elif index == 2:
		OS.window_size = Vector2(1280, 720)
	pass
