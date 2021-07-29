extends KinematicBody2D
var bullet_speed =  5
func _process(delta):
	translate(Vector2(-10,0))
	translate(Vector2(10,0))

