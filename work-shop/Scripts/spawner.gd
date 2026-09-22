extends Node2D

signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)

@export var current_wave :int = 1
@export var total_waves :int = 0 # 0 for infinite waves
@export var wave_interval :float = 5.0 # Delay between waves in seconds
@export var spawns_per_wave :int = 3 # Number of spawns per wave for each spawning point
@export var wave_lifetime :float = 0.0 # Max wave duration in seconds (0 for unlimited)
@export var asteroid_lifetime :float = 15.0 # Lifetime in seconds for spawned asteroids
@onready var area: Area2D = $area

@onready var asteroid_1_scn = preload("res://Scenes/asteroid_1.tscn")

var can_spawn :bool = true
var wave_spawn_count :int = 0
var wave_time_elapsed :float = 0.0
var is_wave_active :bool = true
var is_waiting_for_next_wave :bool = false

func _ready() -> void:
	if area:
		if not area.body_exited.is_connected(_on_area_body_exited):
			area.body_exited.connect(_on_area_body_exited)
	start_wave(current_wave)

func _on_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Asteroid"):
		_bounce_asteroid(body)

func _bounce_asteroid(asteroid: Node2D) -> void:
	if not area or not area.has_node("CollisionShape2D"):
		return
	var col_shape = area.get_node("CollisionShape2D")
	var shape = col_shape.shape
	if shape is RectangleShape2D:
		var half_size = shape.size * 0.5 * col_shape.global_scale
		var center = col_shape.global_position
		var min_bounds = center - half_size
		var max_bounds = center + half_size
		if asteroid.has_method("bounce_from_bounds"):
			asteroid.bounce_from_bounds(min_bounds, max_bounds)
		elif "direction" in asteroid:
			if asteroid.global_position.x <= min_bounds.x:
				asteroid.direction.x = abs(asteroid.direction.x)
			elif asteroid.global_position.x >= max_bounds.x:
				asteroid.direction.x = -abs(asteroid.direction.x)
			if asteroid.global_position.y <= min_bounds.y:
				asteroid.direction.y = abs(asteroid.direction.y)
			elif asteroid.global_position.y >= max_bounds.y:
				asteroid.direction.y = -abs(asteroid.direction.y)


func start_wave(wave_num: int) -> void:
	current_wave = wave_num
	wave_spawn_count = 0
	wave_time_elapsed = 0.0
	is_wave_active = true
	can_spawn = true
	wave_started.emit(current_wave)

func _process(delta: float) -> void:
	if not is_wave_active or is_waiting_for_next_wave:
		return
	
	# Check if all spawns for the current wave have completed
	if wave_spawn_count >= spawns_per_wave:
		wave_time_elapsed += delta
		# Wait until all active asteroids in the wave are destroyed or wave_lifetime expires
		if get_tree().get_nodes_in_group("Asteroid").is_empty() or (wave_lifetime > 0.0 and wave_time_elapsed >= wave_lifetime):
			_complete_wave()
		return
	
	if can_spawn:
		can_spawn = false
		for node in get_children():
			if node is Marker2D:
				var asteroid = asteroid_1_scn.instantiate()
				asteroid.lifetime = asteroid_lifetime
				node.add_child(asteroid)
				asteroid.global_position = node.global_position
				asteroid.direction = node.global_position.direction_to(Global.player_position)
		wave_spawn_count += 1
		$Timer.start()

func _complete_wave() -> void:
	is_wave_active = false
	is_waiting_for_next_wave = true
	wave_completed.emit(current_wave)
	
	if total_waves > 0 and current_wave >= total_waves:
		return # Finished all waves
	
	await get_tree().create_timer(wave_interval).timeout
	is_waiting_for_next_wave = false
	start_wave(current_wave + 1)

func _on_timer_timeout() -> void:
	can_spawn = true
