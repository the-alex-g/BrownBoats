extends KinematicBody2D

export var speed := 100.0
export var lifetime := 1.5
export var lifetime_variance := 0.2

var direction := 0.0
var damage := 0
var boat_direction := 0.0
var time_elapsed := 0.0


func _ready()->void:
	lifetime += lerp(-lifetime_variance, lifetime_variance, randf())


func _physics_process(delta:float)->void:
	var velocity : Vector2 = Vector2.RIGHT.rotated(direction) * lerp(speed, 20, pow(time_elapsed / lifetime, 2))
	# this applies the boat's inertia to the cannonballs
	velocity += Vector2.RIGHT.rotated(boat_direction) * lerp(45, 0, time_elapsed/lifetime)
	var collision := move_and_collide(velocity * delta)
	if collision:
		queue_free()
		if collision.collider.has_method("damage"):
			collision.collider.damage(damage)
	
	time_elapsed += delta
	if time_elapsed >= lifetime:
		queue_free()


func _draw()->void:
	draw_circle(Vector2.ZERO, 2, Color.black)
