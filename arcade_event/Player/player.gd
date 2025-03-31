extends CharacterBody2D

@export var speed :float = 100.0
@export var jump_speed :float = -250
var gravity :float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	$Camera2D.make_current()
	

func get_input(delta :float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	

func _physics_process(delta: float) -> void:
	get_input(delta)
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_speed
	
	move_and_slide()
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("Move")
	elif velocity.x < 0:
		$AnimatedSprite2D.play("Move")
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.play("idle")
	

func _process(delta: float) -> void:
	$Camera2D/Label.text = "SCORE: " + str(Global.score)
	
