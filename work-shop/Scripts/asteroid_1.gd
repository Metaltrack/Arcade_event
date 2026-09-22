extends RigidBody2D

@export var speed :float = 0.0
@export var speed_range :Vector2 = Vector2(400.0, 800.0)
var direction :Vector2 = Vector2.ZERO
@export var health :int = 100
@export var damage :int = 10
@export var lifetime :float = 15.0

var is_dead :bool = false

func _ready() -> void:
	speed = randi_range(speed_range.x, speed_range.y)
	if has_node("Timer"):
		$Timer.wait_time = lifetime
		$Timer.start()
	

func die():
	if is_dead:
		return
	is_dead = true
	Global.score.emit()
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
	

func bounce_from_bounds(min_pos: Vector2, max_pos: Vector2) -> void:
	if is_dead:
		return
	if global_position.x <= min_pos.x:
		direction.x = abs(direction.x) if direction.x != 0.0 else 1.0
		linear_velocity.x = abs(linear_velocity.x) if linear_velocity.x != 0.0 else speed
		global_position.x = min_pos.x + 5.0
	elif global_position.x >= max_pos.x:
		direction.x = -abs(direction.x) if direction.x != 0.0 else -1.0
		linear_velocity.x = -abs(linear_velocity.x) if linear_velocity.x != 0.0 else -speed
		global_position.x = max_pos.x - 5.0
	
	if global_position.y <= min_pos.y:
		direction.y = abs(direction.y) if direction.y != 0.0 else 1.0
		linear_velocity.y = abs(linear_velocity.y) if linear_velocity.y != 0.0 else speed
		global_position.y = min_pos.y + 5.0
	elif global_position.y >= max_pos.y:
		direction.y = -abs(direction.y) if direction.y != 0.0 else -1.0
		linear_velocity.y = -abs(linear_velocity.y) if linear_velocity.y != 0.0 else -speed
		global_position.y = max_pos.y - 5.0


func take_knockback(damage :int, direction :Vector2, force :float) -> void:
	if is_dead:
		return
	apply_impulse(direction * force, Vector2.ZERO)
	health -= damage
	

func _on_timer_timeout() -> void:
	die()
