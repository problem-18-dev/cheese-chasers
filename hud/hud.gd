extends CanvasLayer


@onready var lives_label: Label = $MarginContainer/LivesLabel
@onready var score_label: Label = $MarginContainer/ScoreLabel


func change_lives(new_lives: int) -> void:
	lives_label.text = "Lives: " + str(new_lives)


func change_score(new_score: int) -> void:
	score_label.text = "%06d" % new_score
