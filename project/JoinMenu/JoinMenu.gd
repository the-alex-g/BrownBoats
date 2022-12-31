extends Control

const BOAT_COLORS := [
	Color.brown,
	Color.darkgreen,
	Color.blue,
	Color.saddlebrown,
]

var boats_joined := [-1, -1, -1, -1]
var boat_color_indicies := [-1, -1, -1, -1]


func _input(event:InputEvent)->void:
	if event is InputEventJoypadButton and event.is_pressed():
		match event.button_index:
			0:
				if not boats_joined.has(event.device):
					_add_boat(event.device)
				else:
					_start()
			4:
				if boats_joined.has(event.device):
					boat_color_indicies[event.device] -= 1
					boat_color_indicies[event.device] %= BOAT_COLORS.size()
					get_child(event.device).modulate = BOAT_COLORS[boat_color_indicies[event.device]]
			5:
				if boats_joined.has(event.device):
					boat_color_indicies[event.device] += 1
					boat_color_indicies[event.device] %= BOAT_COLORS.size()
					get_child(event.device).modulate = BOAT_COLORS[boat_color_indicies[event.device]]


func _add_boat(id:int)->void:
	boats_joined.append(id)
	boat_color_indicies.append(0)
	get_child(id).show()
	get_child(id).modulate = BOAT_COLORS[boat_color_indicies[id]]


func _start()->void:
	for i in boats_joined:
		if i != -1:
			BoatStats.add_boat(i, BOAT_COLORS[boat_color_indicies[i]])
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main/World.tscn")
