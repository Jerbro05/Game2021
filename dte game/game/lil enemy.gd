extends KinematicBody2D

export (int) var gravity = 5500
class_name lil 
onready var player = get_tree().get_nodes_in_group("Player")
var state = "idle" 
var speed = 400
var velocity = Vector2.ZERO
var target
var attacking = false

func _ready():
	player = player[0]

func _process(delta):
	if state == "idle":
		idle()
	elif state == "chasing":
		chasing(delta)
	elif state == "attacking":
		$AnimationPlayer.play("swing")
		yield($AnimationPlayer,"animation_finished")
		state = "chasing"

	elif state == "pulling out":
		$AnimationPlayer.play("pulling out")
		yield($AnimationPlayer,"animation_finished")
		state = "holding"
		
	elif state == "putting away":
		$AnimationPlayer.play("putting away")
		yield($AnimationPlayer,"animation_finished")
		state = "idle"

func idle():
	$AnimationPlayer.play("idle") 

func chasing(delta):
	velocity.y += gravity * delta
	var player_position = player.global_position
	if position.x < player_position.x :
		pass
		velocity.x = speed * delta
	else:
		pass
		velocity.x = -speed * delta
	
	if not attacking:
		if velocity.x != 0 :
			$AnimationPlayer.play("run")
			if velocity.x < 0: 
				$Sprite.flip_h = true
			else: 
				$Sprite.flip_h = false
		else:
			$AnimationPlayer.play("idle") 
		
	if target:
		velocity = move_and_slide(velocity, Vector2.UP)
		position = position.move_toward(player_position, speed * delta)

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		state = "chasing"

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		attacking = false
		target = null
		state = "putting away"

func _on_Area2D2_body_entered(body):
	if body.is_in_group("Player"):
		attacking = false
		target = body
		state = "pulling out"

func _on_swipe_body_entered(body):
	if body.is_in_group("Player"):
		attacking = true
		body.damage(-25)
		state = "attacking"
