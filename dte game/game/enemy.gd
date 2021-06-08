extends KinematicBody2D

export (int) var gravity = 5500
class_name Enemy
onready var player = get_tree().get_nodes_in_group("Player")
var state = "chasing"  
var speed = 250
var velocity = Vector2.ZERO

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
	velocity.y += gravity * delta

	var player_position = player.global_position
	if position.x < player_position.x :
		pass
		velocity.x = speed * delta
	else:
		pass
		velocity.x = -speed * delta
	
	if velocity.x != 0 :
		$AnimationPlayer.play("walk")
		if velocity.x < 0: 
			$Sprite.flip_h = true
		else: 
			$Sprite.flip_h = false
	else:
		$AnimationPlayer.play("idle") 

		
	velocity = move_and_slide(velocity, Vector2.UP)
	position = position.move_toward(player_position, speed * delta)
