extends KinematicBody2D

export (int) var gravity = 5500
class_name Enemy
onready var player = get_tree().get_nodes_in_group("Player")
var state = "idle" 
var speed = 150
var velocity = Vector2.ZERO
var target
var attacking = false
var health = 30

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

func idle():
	$AnimationPlayer.play("idle") 
	attacking = false

func chasing(delta):
	velocity.y += gravity * delta
	var player_position = player.global_position
	if global_position.x < player_position.x :
		velocity.x = speed * delta
	else:
		velocity.x = -speed * delta
	

	if not attacking:
		if velocity.x != 0 :
			$AnimationPlayer.play("walk")
			if velocity.x < 0: 
				$Sprite.flip_h = true
			else: 
				$Sprite.flip_h = false
		else:
			$AnimationPlayer.play("idle") 

	if target:
		velocity = move_and_slide(velocity * speed, Vector2.UP)
		#position = position.move_toward(player_position, speed * delta)

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		attacking = false
		target = body
		state = "chasing"

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		attacking = false
		target = null
		state = "idle"

func _on_swing_body_entered(body):
	if body.is_in_group("Player"):
		attacking = true
		body.damage(-15)
		state = "attacking"

func kill():
	health -= 20
	if health <= 0:
		state = "bones"
		$AnimationPlayer.play("death")
		set_process(false)
		set_physics_process(false)
		$chasing/CollisionShape2D.disabled = true
		$swing/CollisionShape2D.disabled = true

