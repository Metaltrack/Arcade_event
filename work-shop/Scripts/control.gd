extends Control

func _process(delta: float) -> void:
	$Label.text = "HEALTH: " + str(Global.player_health)
