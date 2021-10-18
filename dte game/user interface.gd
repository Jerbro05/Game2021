extends CanvasLayer



func visibility(val):
	
	for child in get_children():
		if val == false:
			child.hide()
		else:
			child.show()
