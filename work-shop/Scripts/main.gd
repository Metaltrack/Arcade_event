extends Node2D

func _ready() -> void:
	Global.player_hit.connect(do_cam_shake)
	

func do_cam_shake():
	$AnimationPlayer.play("cam_shake")
	

func _on_button_pressed() -> void:
	$CanvasLayer/Control/Button.visible = false
	Global.start = true
