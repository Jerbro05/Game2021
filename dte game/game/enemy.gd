extends Node

class_name Enemy

var state = "Idle"  
var speed = 5


func _process(delta):
	if state == "idle":
		idle()
	elif state == "chasing":
		chasing()
	else:
		patrol()


func idle():
	pass


func patrol():
	pass



func chasing():
	var player_position = get_global_position()
	move_to(player_position)
