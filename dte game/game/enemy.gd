extends KinematicBody2D

class_name Enemy
onready var player = get_tree().get_nodes_in_group("Player")
var state = "chasing"  
var speed = 500

func _ready():
	player = player[0]
	
func _process(delta):
	if state == "idle":
		idle()
	elif state == "chasing":
		chasing(delta)
	else:
		patrol()


func idle():
	pass


func patrol():
	pass

func chasing(delta):
	var player_position = player.global_position
	position = position.move_toward(player_position, speed * delta)
