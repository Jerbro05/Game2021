extends KinematicBody2D

export (int) var gravity = 5500
class_name reeper
onready var player = get_tree().get_nodes_in_group("Player")
var state = "fade" 
var speed = 175
var velocity = Vector2.ZERO
var target
var can_see = false
var attacking = false
var health = 65

func _ready():
	player = player[0]

func _process(delta):
	if state == "idle":
		idle()
	elif state == "chasing":
		chasing(delta)
	elif state == "life":
		can_see = true
		$AnimationPlayer.play("life")
		yield($AnimationPlayer,"animation_finished")
		state = "idle"

func idle():
	$AnimationPlayer.play("idle") 

func chasing(delta):
	var player_position = player.global_position
	if global_position.x < player_position.x :
		velocity.x = speed * delta
	else:
		velocity.x = -speed * delta
	
	if global_position.y < player_position.y :
		velocity.y = speed/2 * delta
	else:
		velocity.y = -speed/2 * delta
		
	if not attacking:
		if velocity.x != 0 : 
			$AnimationPlayer.play("idle")
			if velocity.x < 0: 
				$Sprite.flip_h = true
			else: 
				$Sprite.flip_h = false
		else:
			$AnimationPlayer.play("fade") 

	if target:
		velocity = move_and_slide(velocity * speed, Vector2.UP)
		#movment

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		state = "chasing"

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		target = null
		state = "idle"

func _on_Area2D2_body_entered(body):
	if can_see:
		return
	if body.is_in_group("Player"):
		target = body
		state = "life"

func _on_playerDamage_body_entered(body):
	if body.is_in_group("Player"):
		attacking = true
		$AnimationPlayer.play("swipe")
		body.damage(-25)

func _on_playerDamage_body_exited(body):
	if body.is_in_group("Player"):
		attacking = false
#		$AnimationPlayer.play("fade")

func kill():
	health -= 20
	if health <= 0:
		state = "dead"
		$AnimationPlayer.play("death")
		set_process(false)
		set_physics_process(false)
		$ChaseZone/CollisionShape2D.disabled = true
		$AppearArea/CollisionShape2D.disabled = true

