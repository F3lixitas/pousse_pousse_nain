extends Button

func _pressed():
	ProjectSettings.set_setting("display/window/size/width", 1080)
	get_tree().quit()
	pass


