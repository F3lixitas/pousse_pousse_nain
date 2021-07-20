extends Node2D

var menuActive = false
var menu = load("res://scenes/submenu.tscn")
var inst = menu.instance()

func _unhandled_key_input(event):
	if event is InputEventKey and event.is_pressed() and event.scancode == KEY_ESCAPE:
		if not menuActive:
			add_child(inst)
			menuActive = true
		else:
			remove_child(inst)
			menuActive = false
