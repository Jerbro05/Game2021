extends KinematicBody2D

export (int) var gravity = 5500
class_name boss
onready var player = get_tree().get_nodes_in_group("Player")
var state = "not_awake" 
var speed = 250
var velocity = Vector2.ZERO
var target
var can_see = false
var attacking = false
var attack_cooldown_time = 1000
var next_attack_time = 1
var attack_damage = 30

func _ready():
	player = player[0]

func _process(delta):
	if state == "idle":
		idle()
	elif state == "chasing":
		chasing(delta)
	elif state == "waking_up":
		can_see = true
		$AnimationPlayer.play("waking_up")
		yield($AnimationPlayer,"animation_finished")
		state = "idle"

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
		print("checking flip",delta)
		if velocity.x != 0 : 
			$AnimationPlayer.play("fly")
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
		state = "chasing"
		attacking = false

func _on_chasing_body_exited(body):
	if body.is_in_group("Player"):
		target = null
		state = "idle"
		attacking = false

func _on_close_attack_body_entered(body):
	if body.is_in_group("Player"):
		attacking = true
		$AnimationPlayer.play("close")
		body.damage(-45)

func _on_close_attack_body_exited(body):
	if body.is_in_group("Player"):
		attacking = false

func _on_undefence_body_entered(body):
	if can_see:
		return
	if body.is_in_group("Player"):
		target = body
		state = "waking_up"
		attacking = false

