extends Area2D
var bullet_speed =  5
var direction = 1 #-1 left
func _process(delta):
	translate(Vector2(25*direction,0))

func _ready():
	if direction == -1:
		$sprite.flip_h = true

#10 damage



func _on_swipe_1_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= 10
		if body.health <= 0:
			body.kill()
