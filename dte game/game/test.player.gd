extends KinematicBody2D

signal health_updated(health)
signal killed()

export (int) var speed = 600
export (int) var jump_speed = -1600
export (int) var gravity = 5500
export (float) var max_health = 100
export var slash_speed = 1500
export var fire_rate = 7

onready var health = max_health setget _set_health

var can_fire = true
var is_dead = false
var slash_1 = preload("res://slash 1.tscn")
var slash_2 = preload("res://slash 2.tscn")

var velocity = Vector2.ZERO

export (float, 0, 1.0) var friction = 0.5
export (float, 0, 1.0) var acceleration = 0.1

func get_input():
	var dir = 0
	if Input.is_action_pressed("right"):
		dir += 1
	if Input.is_action_pressed("left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed
	
	if Input.is_action_pressed("right_click") and can_fire:
		var slash_1_instance = slash_1.instance()
		slash_1_instance.global_position = get_global_position()
		get_tree().get_root().add_child(slash_1_instance)
		
	if Input.is_action_pressed("left_click") and can_fire:
		var slash_2_instance = slash_2.instance()
		get_tree().get_root().add_child(slash_2_instance)
		slash_2_instance.global_position = get_global_position()
		
	
	if velocity.x != 0 :
		$AnimationPlayer.play("run")
		if velocity.x < 0: 
			$Sprite.flip_h = true
		else: 
			$Sprite.flip_h = false
	else:
		$AnimationPlayer.play("idle") 

	if not is_on_floor():
		if velocity.y < 0:
			$AnimationPlayer.play("jump")
		if velocity.y > 0:
			$AnimationPlayer.play("drop")

	if is_on_floor():
		if Input.is_action_pressed("left_click"):
			$AnimationPlayer.play("swipe_1")
		if Input.is_action_pressed("right_click"):
			$AnimationPlayer.play("swipe_2")

func damage(amount):
	_set_health(health - amount)

func kill():
	pass

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")
