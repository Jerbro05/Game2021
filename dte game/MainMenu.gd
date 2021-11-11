extends MarginContainer

const world = preload("res://tutoral.tscn")

onready var picker_one = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/picker
onready var picker_two = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/picker

var current_selection = 0

func _ready():
	set_current_selection(0)
	UserInterface.visibility(false)

func _process(delta):
	if Input.is_action_just_pressed("ui_down") and current_selection < 2:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selection)
		
func handle_selection(_current_selection):
	if _current_selection == 0:
		UserInterface.visibility(true)
		get_tree().change_scene("res://tutoral.tscn")
	elif _current_selection == 2:
		get_tree().quit()

func set_current_selection(_current_selection):
	picker_one.text = ""
	picker_two.text = ""
	if _current_selection == 0:
		picker_one.text = ">"
	if _current_selection == 1:
		picker_two.text = ">"
