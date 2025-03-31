extends Area2D

var sound 

func _ready() -> void:
	sound = load("res://coinPickupArcadePlatformer/sounds/coin.wav")
	$AudioStreamPlayer2D.stream = sound

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.score += 1
		$AudioStreamPlayer2D.play()
		$AnimatedSprite2D.visible = false
		await $AudioStreamPlayer2D.finished
		queue_free()
