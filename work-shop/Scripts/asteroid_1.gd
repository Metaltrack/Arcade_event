extends RigidBody2D

@export var speed :float = 0.0
@export var speed_range :Vector2 = Vector2.ZERO
@export var direction :Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	apply_central_force(direction * speed * delta)
	

func take_knockback(damage :int, direction :Vector2, force :float) -> void:
	apply_impulse(direction * force, Vector2.ZERO)
	

func _on_timer_timeout() -> void:
	queue_free()
