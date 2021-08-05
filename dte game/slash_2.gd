extends Area2D
var bullet_speed =  5 
var direction = 1 #-1 left
func _process(delta):
	translate(Vector2(25*direction,0))

func _ready():
	if direction == -1:
		$sprite.flip_h = true
