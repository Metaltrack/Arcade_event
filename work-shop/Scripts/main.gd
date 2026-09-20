extends Node2D

func _ready() -> void:
	Global.player_hit.connect(do_cam_shake)
	

func do_cam_shake():
	$AnimationPlayer.play("cam_shake")
	
