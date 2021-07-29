extends KinematicBody2D

export (int) var gravity = 5500
class_name bird
onready var player = get_tree().get_nodes_in_group("Player")
var state = "idle" 
var speed = 400
var velocity = Vector2.ZERO
var target
var can_see = false
var attacking = false

func _ready():
	player = player[0]

func _process(delta):
	if state == "idle":
		idle()
	elif state == "chasing":
		chasing(delta)

func idle():
	$AnimationPlayer.play("idle") 

func chasing(delta):
	velocity.y += delta
	var player_position = player.global_position
	if position.x < player_position.x :
		velocity.x = speed * delta
	else:
		velocity.x = -speed * delta
		
	if not attacking:
		if velocity.x != 0 : 
			$AnimationPlayer.play("swipe")
			if velocity.x < 0: 
				$Sprite.flip_h = true
			else: 
				$Sprite.flip_h = false
		else:
			$AnimationPlayer.play("idle") 

	if target:
		velocity = move_and_slide(velocity, Vector2.UP)
		position = position.move_toward(player_position, speed * delta)

func _on_chasing_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		state = "flying"
