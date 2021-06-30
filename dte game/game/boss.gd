extends KinematicBody2D

export (int) var gravity = 5500
class_name boss
onready var player = get_tree().get_nodes_in_group("Player")
var state = "idle" 
var speed = 250
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
	elif state == "undefence":
		can_see = true
		$AnimationPlayer.play("undefence")
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
#
#func _on_Area2D_body_exited(body):
#	if body.is_in_group("Player"):
#		target = null
#		state = "idle"
#
#func _on_Area2D2_body_entered(body):
#	if can_see:
#		return
#	if body.is_in_group("Player"):
#		target = body
#		state = "life"
#
#func _on_playerDamage_body_entered(body):
#	if body.is_in_group("Player"):
#		attacking = true
#		$AnimationPlayer.play("swipe")
#		body.damage(-35)
#
#func _on_playerDamage_body_exited(body):
#	if body.is_in_group("Player"):
#		attacking = false
#		$AnimationPlayer.play("fade")
#

func _on_chasing_area_entered(area):
	if area.is_in_group("Player"):
		target = area
		state = "chasing"

func _on_chasing_area_exited(area):
	if area.is_in_group("Player"):
		target = null
		state = "idle"

func _on_undefence_area_entered(body):
	if can_see:
		return
	if body.is_in_group("Player"):
		target = body
		state = "undefence"

func _on_close_attack_area_entered(body):
	if body.is_in_group("Player"):
		attacking = true
		$AnimationPlayer.play("swipe")
		body.damage(-35)
