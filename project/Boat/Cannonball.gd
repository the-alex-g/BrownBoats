extends KinematicBody2D

export var speed := 80.0
export var lifetime := 1.0
export var lifetime_variance := 0.2

var direction := 0.0


func _ready()->void:
	$LifeTimer.start(lifetime + lerp(-lifetime_variance, lifetime_variance, randf()))


func _physics_process(delta:float)->void:
	var collision := move_and_collide(Vector2.RIGHT.rotated(direction) * speed * delta)
	if collision:
		queue_free()


func _draw()->void:
	draw_circle(Vector2.ZERO, 2, Color.black)


func _on_LifeTimer_timeout()->void:
	queue_free()
