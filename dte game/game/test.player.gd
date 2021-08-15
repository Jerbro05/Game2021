extends KinematicBody2D

signal health_updated(health)
signal killed()

export (float, 0, 1.0) var friction = 70
export (float, 0, 1.0) var acceleration = 75 
export (int) var speed = 600
export (int) var jump_speed = -1600
export (int) var gravity = 5500
export (float) var max_health = 100
export var slash_speed = 1500
export var fire_rate = .6

onready var health = max_health setget _set_health

var facing = 1
var animation_state 
var attacking = false
var melee_1 = false
var melee_2 = false
var damage 
var can_fire = true
var is_dead = false
onready var slash_1 = preload("res://slash_1.tscn")
onready var slash_2 = preload("res://slash_2.tscn")
var velocity = Vector2.ZERO

func get_input():
	var dir = 0
	if Input.is_action_pressed("right"):
		dir += 1
	if Input.is_action_pressed("left"):
		dir -= 1
	if dir != 0:
		velocity.x = move_toward(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed

	if is_on_floor():
		if velocity.x != 0:
			animation_state.travel("run")
			if velocity.x < 0: 
				$Sprite.flip_h = true
				facing = -1

			else: 
				$Sprite.flip_h = false
				facing = 1
		else:
			animation_state.travel("idle") 

	if not is_on_floor():
		if velocity.y < 0:
			animation_state.travel("jump")
		if velocity.y > 0:
			animation_state.travel("drop")
	
	if Input.is_action_pressed("right_click") and can_fire:
		animation_state.travel("swipe_1")


	elif Input.is_action_pressed("left_click") and can_fire:
		animation_state.travel("swipe_2")

func slash_1_attack():
	var slash_1_instance = slash_1.instance()
	slash_1_instance.global_position = get_global_position()
	slash_1_instance.direction = facing
	get_tree().get_root().add_child(slash_1_instance)

func slash_2_attack():
		var slash_2_instance = slash_2.instance()
		slash_2_instance.direction = facing
		get_tree().get_root().add_child(slash_2_instance)
		slash_2_instance.global_position = get_global_position()

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


func _on_slash_1_damage_zone_body_entered(body):
	pass

func _ready():
	animation_state = $AnimationTree.get("parameters/playback")

func _on_slash_2_damage_zone_body_entered(body):
	pass
