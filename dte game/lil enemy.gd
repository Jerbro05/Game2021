extends KinematicBody2D

export (int) var gravity = 5500
class_name lil 
onready var player = get_tree().get_nodes_in_group("Player")
var state = "idle" 
var speed = 250
var velocity = Vector2.ZERO
var target

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
	velocity.y += gravity * delta
	var player_position = player.global_position
	if position.x < player_position.x :
		pass
		velocity.x = speed * delta
	else:
		pass
		velocity.x = -speed * delta
	
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
		target = null
		state = "idle"

func _on_Area2D_area_shape_exited(area_id, area, area_shape, local_shape):
	pass 

func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
	pass 

