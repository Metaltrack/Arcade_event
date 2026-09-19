extends Area2D

@export var speed :float = 1500.0
@export var damage :int = 20
var direction

func _ready() -> void:
	top_level = true
	look_at(get_global_mouse_position())
	

func _physics_process(delta: float) -> void:
	if direction:
		global_position += direction * speed * delta
	

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Asteroid"):
		if body.has_method("take_knockback"):
			body.take_knockback(10, direction, 200.0)
	
	queue_free()
	
