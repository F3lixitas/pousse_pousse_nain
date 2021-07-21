extends Button

var menuActive = false
var menu = load("res://scenes/menu_optionPannel_display.tscn")
var inst = menu.instance()


func _pressed():
	if not menuActive:
		get_parent().get_parent().get_child(1).add_child(inst)
		menuActive = true
	else:
		get_parent().get_parent().get_child(1).remove_child(inst)
		menuActive = false
