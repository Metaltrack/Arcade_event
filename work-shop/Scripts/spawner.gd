extends Node2D

@export var spawn_limit :int = 1
@onready var asteroid_1_scn = preload("res://Scenes/asteroid_1.tscn")
var can_spawn :bool = true

func _process(delta: float) -> void:
	if $Marker2D.get_child_count() >= spawn_limit:
		return
	
	if can_spawn:
		can_spawn = false
		for node in get_children():
			if node is Marker2D:
				var asteroid = asteroid_1_scn.instantiate()
				node.add_child(asteroid)
				asteroid.global_position = node.global_position
				asteroid.direction = node.global_position.direction_to(Global.player_position)
		$Timer.start()
	

func _on_timer_timeout() -> void:
	can_spawn = true
