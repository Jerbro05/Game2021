extends KinematicBody2D

var speed = 400
export var jump_power = 7500

const GRAVITY = 5
const WALK_SPEED = 200
const JUMP = 7500

var velocity = Vector2()

func _ready():
	set_process(true)

func _physics_process(delta):
	var grounded = is_on_floor()
	velocity.y += GRAVITY
	velocity.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	velocity.x *= WALK_SPEED
	
	if Input.is_action_just_pressed("ui_accept") and grounded:
		$AnimationPlayer.play("jump")
		velocity.y += -jump_power  
		
	velocity = move_and_slide(velocity, Vector2.UP)
		
	if grounded:
		velocity.y = 0
		
		
		if velocity.x != 0 :
			$AnimationPlayer.play("run")
			if velocity.x < 0: 
				$Sprite.flip_h = true

			else: 
				$Sprite.flip_h = false
		else:
			$AnimationPlayer.play("idle") 
	
	else:
		if velocity.y < 0:
			$AnimationPlayer.play("jump")
		if velocity.y > 0:
			$AnimationPlayer.play("drop")

	
	
	
	

