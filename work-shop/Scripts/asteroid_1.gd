extends RigidBody2D

@export var speed :float = 0.0
@export var speed_range :Vector2 = Vector2(400.0, 800.0)
var direction :Vector2 = Vector2.ZERO
@export var health :int = 100
@export var damage :int = 10

func _ready() -> void:
	speed = randi_range(speed_range.x, speed_range.y)
	

func die():
	$Sprite2D.visible = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("default")
	await $AnimatedSprite2D.animation_finished
	queue_free()
	

func _process(delta: float) -> void:
	if health <= 0:
		die()
		return

func _physics_process(delta: float) -> void:
	apply_central_force(direction * speed)
	

func take_knockback(damage :int, direction :Vector2, force :float) -> void:
	apply_impulse(direction * force, Vector2.ZERO)
	health -= damage
	

func _on_timer_timeout() -> void:
	die()
