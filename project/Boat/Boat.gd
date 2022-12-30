class_name Boat
extends KinematicBody2D

export var speed := 45
# turn speed in revolutions per second
export var turn_speed := 0.01
export var accel_factor := 0.01
export var deaccel_factor := 0.01

var id := 0
var _turn_inertia := 0.0

onready var _load_timer : Timer = $LoadTimer


func _ready()->void:
	$Sprite.self_modulate = BoatStats.colors[id]


func _physics_process(delta:float)->void:
	var str_id := str(id)
	var rotate_value := Input.get_axis("left_" + str_id, "right_" + str_id) * delta * TAU * accel_factor
	
	if rotate_value != 0.0:
		if abs(_turn_inertia) < turn_speed:
			_turn_inertia += rotate_value
	elif abs(_turn_inertia) > 0.0:
		_turn_inertia -= deaccel_factor * delta * sign(_turn_inertia)
	
	rotation += _turn_inertia
	
	var direction := Vector2.RIGHT.rotated(rotation)
	# warning-ignore:return_value_discarded
	move_and_collide(direction * speed * delta)
	
	if Input.is_action_just_pressed("shoot_" + str_id) and BoatStats.cannons_loaded[id] > 0:
		_shoot()


func _shoot()->void:
	var Cannonball := preload("res://Boat/Cannonball.tscn")
	for i in BoatStats.cannons_loaded[id]:
		# fire port side cannon
		var cannonball := Cannonball.instance()
		cannonball.position = lerp($PortLimit1.global_position, $PortLimit2.global_position, float(i) / (BoatStats.cannons[id] - 1))
		cannonball.direction = rotation - PI / 2
		get_parent().add_child(cannonball)
		
		# fire starboard side cannon
		cannonball = Cannonball.instance()
		cannonball.position = lerp($StarboardLimit1.global_position, $StarboardLimit2.global_position, float(i) / (BoatStats.cannons[id] - 1))
		cannonball.direction = rotation + PI / 2
		get_parent().add_child(cannonball)
		
	BoatStats.cannons_loaded[id] = 0
	_load_timer.start()


func _on_LoadTimer_timeout()->void:
	if BoatStats.cannons_loaded[id] < BoatStats.cannons[id]:
		BoatStats.cannons_loaded[id] += 1
	else:
		_load_timer.stop()
