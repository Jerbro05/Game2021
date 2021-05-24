extends KinematicBody2D

export (int) var speed = 1200
export (int) var jump_speed = -1800
export (int) var gravity = 4000

var velocity = Vector2.ZERO

export (float, 0, 1.0) var friction = 0.5
export (float, 0, 1.0) var acceleration = 0.1

func get_input():
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	print(is_on_floor())
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = jump_speed
	
#		if velocity.x != 0 :
#			$AnimationPlayer.play("run")
#			if velocity.x < 0: 
#				$Sprite.flip_h = true
#
#			else: 
#				$Sprite.flip_h = false
#		else:
#			$AnimationPlayer.play("idle") 
#
#	else:
#		if velocity.y < 0:
#			$AnimationPlayer.play("jump")
#		if velocity.y > 0:
#			$AnimationPlayer.play("drop")
