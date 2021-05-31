extends CanvasLayer

func _ready():
	pass
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$ColorRect.visible = !$ColorRect.visible
		get_tree().paused = !get_tree().paused
