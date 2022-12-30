extends Node2D


func _ready()->void:
	for i in BoatStats.boats:
		var boat : Boat = load("res://Boat/Boat.tscn").instance()
		boat.position = Vector2(lerp(100, 924, float(i) / BoatStats.boats), 300)
		boat.id = i
		add_child(boat)
