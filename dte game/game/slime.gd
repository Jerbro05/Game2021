extends KinematicBody2D

export (int) var gravity = 5500
class_name slime 
onready var player = get_tree().get_nodes_in_group("Player")
var state = "idle" 
var speed = 100
var velocity = Vector2.ZERO
var target
var attacking = false
var health = 20

func _ready():
	player = player[0]

func _process(delta):
	if state == "dead":
		return
	elif state == "idle":
		idle()
	elif state == "sliming":
		chasing(delta)
	elif state == "spitting":
		$AnimationPlayer.play("spitting")
		yield($AnimationPlayer,"animation_finished")
		state = "sliming"
	

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
			$AnimationPlayer.play("sliming")
			if velocity.x < 0: 
				$Sprite.flip_h = false
			else: 
				$Sprite.flip_h = true
		else:
			$AnimationPlayer.play("idle") 

	if target:
		velocity = move_and_slide(velocity * speed, Vector2.UP)
#		position = position.move_toward(player_position, speed * delta)

func _on_chasing_body_entered(body):
	if body.is_in_group("Player"):
		attacking = false
		target = body
		state = "sliming"

func _on_chasing_body_exited(body):
	if body.is_in_group("Player"):
		attacking = false
		target = null
		state = "idle"
		
func _on_spitting_body_entered(body):
	if body.is_in_group("Player"):
		attacking = true
		body.damage(-35)
		state = "spitting"

func kill_slime():
	health -= 20
	if health <= 0:
		state = "dead"
		$AnimationPlayer.play("death")
		$chasing/CollisionShape2D.disabled = true
		$chasing/CollisionShape2D.disabled = true
		yield($AnimationPlayer,"animation_finished")
		$AnimationPlayer.play("dead")
		
