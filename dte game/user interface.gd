extends CanvasLayer

func _ready():
	$HealthBar.max_value = PlayerStats.health_max

func _process(delta):
	$HealthBar.value = PlayerStats.get_health()
	$LifeCounter.text = "X" + str(PlayerStats.get_lives())

func visibility(val):
	for child in get_children():
		if val == false:
			child.hide()
		else:
			child.show()
