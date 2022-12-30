extends Panel

var id : int setget _set_id

onready var _cannon_bar : ProgressBar = $VBoxContainer/CannonBar
onready var _hull_bar : ProgressBar = $VBoxContainer/HullBar
onready var _sail_bar : ProgressBar = $VBoxContainer/SailBar


func _set_id(value:int)->void:
	id = value
	show()


func _ready()->void:
	_cannon_bar.max_value = BoatStats.cannons[id]


func _process(_delta:float)->void:
	_cannon_bar.value = BoatStats.cannons_loaded[id]
	_sail_bar.value = BoatStats.sails[id]
	_hull_bar.value = BoatStats.hull[id]
