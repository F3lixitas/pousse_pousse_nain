extends Node2D

var menuActive = false
var menu = load("res://scenes/submenu.tscn")
var inst = menu.instance()

func _input(event):
	if Input.is_action_just_pressed("open_menu"):
		if not menuActive:
			add_child(inst)
			menuActive = true
		else:
			remove_child(inst)
			menuActive = false
