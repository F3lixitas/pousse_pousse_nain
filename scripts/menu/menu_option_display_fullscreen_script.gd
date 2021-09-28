extends CheckButton

# todo : sauvegarder cette valeur
var fullscreen = OS.window_fullscreen


func _pressed():
	fullscreen = !fullscreen
	OS.window_fullscreen = fullscreen
	pass

func _init():
	pressed = fullscreen
