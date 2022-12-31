extends Node

var boats := 0
var colors := [Color.white, Color.white, Color.white, Color.white]
var cannons := [4, 4, 4, 4]
var cannons_loaded := [0, 0, 0, 0]
var hull := [100, 100, 100, 100]
var sails := [100, 100, 100, 100]


func add_boat(id:int, color:Color)->void:
	boats += 1
	colors[id] = color
	InputMap.add_action("shoot_" + str(id))
	InputMap.add_action("left_" + str(id))
	InputMap.add_action("right_" + str(id))
	InputMap.add_action("sail_" + str(id))
	
	_add_joy_button_event(id, JOY_XBOX_X, "shoot_" + str(id))
	_add_joy_button_event(id, JOY_BUTTON_7, "sail_" + str(id))
	_add_joy_motion_event(id, JOY_AXIS_0, -1.0, "left_" + str(id))
	_add_joy_motion_event(id, JOY_AXIS_0, 1.0, "right_" + str(id))


func _add_joy_button_event(id:int, button:int, action:String)->void:
	var event := InputEventJoypadButton.new()
	event.device = id
	event.button_index = button
	InputMap.action_add_event(action, event)


func _add_joy_motion_event(id:int, axis:int, axis_value:float, action:String)->void:
	var event := InputEventJoypadMotion.new()
	event.device = id
	event.axis = axis
	event.axis_value = axis_value
	InputMap.action_add_event(action, event)
