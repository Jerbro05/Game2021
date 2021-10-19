extends KinematicBody2D

export (int) var gravity = 5500
class_name bird
onready var player = get_tree().get_nodes_in_group("Player")
var state = "idle" 
var speed = 125
var velocity = Vector2.ZERO
var target
var can_see = false
var attacking = false
var attack_cooldown_time = 1000
var next_attack_time = 1
var attack_damage = 20
var health = 20

func _ready():
	player = player[0]

func _process(delta):
	if state == "idle":
		idle()
	elif state == "flying":
		chasing(delta)


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
			$AnimationPlayer.play("flying")
			if velocity.x > 0: 
				$Sprite.flip_h = true
			else: 
				$Sprite.flip_h = false
		else:
			$AnimationPlayer.play("idle") 

	if target:
		velocity = move_and_slide(velocity * speed, Vector2.UP)

func _on_chasing_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		state = "flying"
		attacking = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		attacking = true
		$AnimationPlayer.play("swipe")
		body.damage(-15)
		
func kill_bird():
	health -= 20
	if health <= 0:
		$AnimationPlayer.play("death")
		yield($AnimationPlayer,"animation_finished")
	state = "dead"
