extends CharacterBody2D

@export var speed :float = 200.0
@export var acceleration :float = 2.0
@export var health :int = 100
var directiom :Vector2 = Vector2.ZERO
var can_fire :bool = true
var muzzel_switch :bool = false

@onready var bullet_scn = preload("res://Scenes/bullet.tscn")
@onready var screen_size = get_viewport_rect().size

func shoot() -> void:
	var bullet = bullet_scn.instantiate()
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	if !muzzel_switch:
		bullet.global_position = $Weapons/muzzle.global_position
		$Weapons/muzzle.add_child(bullet)
		muzzel_switch = !muzzel_switch
	else:
		bullet.global_position = $Weapons/muzzle2.global_position
		$Weapons/muzzle2.add_child(bullet)
		muzzel_switch = !muzzel_switch
	

func _process(delta: float) -> void:
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)
	
	if Input.is_action_pressed("fire"):
		if can_fire:
			can_fire = false
			$Timer.start()
			shoot()
	
	Global.player_health = health
	

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	directiom.x = Input.get_axis("move_left", "move_right")
	directiom.y = Input.get_axis("move_up", "move_down")
	
	if directiom != Vector2.ZERO:
		$Thrust.visible = true
	else:
		$Thrust.visible = false
	
	velocity = directiom * speed
	velocity = lerp(get_real_velocity(), velocity, acceleration * delta)
	
	move_and_slide()
	

func _on_timer_timeout() -> void:
	can_fire = true
