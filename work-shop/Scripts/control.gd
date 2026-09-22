extends Control

@onready var health: Label = $health
@onready var score: Label = $score

var current_score :int = 0

func _ready() -> void:
	Global.score.connect(on_score)
	score.text = "SCORE: " + str(current_score)

func on_score() -> void:
	current_score += 1
	score.text = "SCORE: " + str(current_score)

func _process(delta: float) -> void:
	health.text = "HEALTH: " + str(Global.player_health)
