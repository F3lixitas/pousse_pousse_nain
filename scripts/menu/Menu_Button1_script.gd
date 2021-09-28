extends Button

func _pressed():
	var mainScene = load("res://scenes/Scene_prototype.tscn")
	get_tree().change_scene_to(mainScene)
	pass
