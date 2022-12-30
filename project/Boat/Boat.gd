extends KinematicBody2D

export var speed := 45
# turn speed in revolutions per second
export var turn_speed := 0.01
export var accel_factor := 0.01
export var deaccel_factor := 0.01

var id := "0"
var _turn_inertia := 0.0
var _cannons := 4
var _cannons_loaded := 4

onready var _load_timer : Timer = $LoadTimer


func _physics_process(delta:float)->void:
	var rotate_value := Input.get_axis("left_" + id, "right_" + id) * delta * TAU * accel_factor
	
	if rotate_value != 0.0:
		if abs(_turn_inertia) < turn_speed:
			_turn_inertia += rotate_value
	elif abs(_turn_inertia) > 0.0:
		_turn_inertia -= deaccel_factor * delta * sign(_turn_inertia)
	
	rotation += _turn_inertia
	
	var direction := Vector2.RIGHT.rotated(rotation)
	# warning-ignore:return_value_discarded
	move_and_collide(direction * speed * delta)
	
	if Input.is_action_just_pressed("shoot_" + id) and _cannons_loaded > 0:
		_shoot()


func _shoot()->void:
	var Cannonball := preload("res://Boat/Cannonball.tscn")
	for i in _cannons_loaded:
		# fire port side cannon
		var cannonball := Cannonball.instance()
		cannonball.position = lerp($PortLimit1.global_position, $PortLimit2.global_position, float(i) / (_cannons - 1))
		cannonball.direction = rotation - PI / 2
		get_parent().add_child(cannonball)
		
		# fire starboard side cannon
		cannonball = Cannonball.instance()
		cannonball.position = lerp($StarboardLimit1.global_position, $StarboardLimit2.global_position, float(i) / (_cannons - 1))
		cannonball.direction = rotation + PI / 2
		get_parent().add_child(cannonball)
		
	_cannons_loaded = 0
	_load_timer.start()


func _on_LoadTimer_timeout()->void:
	if _cannons_loaded < _cannons:
		_cannons_loaded += 1
		print("loading ", _cannons_loaded)
	else:
		_load_timer.stop()
