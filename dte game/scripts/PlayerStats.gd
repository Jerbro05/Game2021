extends Node

var health
var health_max 
var lives
var lives_max

func _ready():
	health = 100
	health_max = 100
	lives = 2
	lives_max = 3

func change_health(ammount):
	health += ammount
	health = clamp(health,0, health_max)

func change_lives(ammount):
	lives += ammount
	lives = clamp(lives,0, lives_max)

func get_health():
	return health
	
func get_lives():
	return lives
