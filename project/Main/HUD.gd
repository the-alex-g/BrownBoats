extends CanvasLayer


func _ready()->void:
	for i in BoatStats.boats:
		get_child(i).id = i
