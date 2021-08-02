extends Button

var menuActive = false
var menu = load("res://scenes/menu_optionPannel.tscn")
var inst = menu.instance()


func _pressed():
	#inst.show_behind_parent = true
	if not menuActive:
		get_parent().get_child(0).add_child(inst)
		menuActive = true
	else:
		get_parent().get_child(0).remove_child(inst)
		menuActive = false
