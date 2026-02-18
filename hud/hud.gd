extends CanvasLayer


signal game_resumed
signal game_quit

@onready var stats: Control = $MarginContainer/Stats
@onready var score_label: Label = $MarginContainer/Stats/ScoreLabel
@onready var lives_label: Label = $MarginContainer/Stats/LivesLabel
@onready var double_score_label: Label = $MarginContainer/Stats/DoubleScoreLabel

@onready var game_over_container: VBoxContainer = $GameOverContainer
@onready var high_score_label: Label = $GameOverContainer/HighScoreLabel
@onready var pause_container: VBoxContainer = $PauseContainer
@onready var pause_label: Label = $PauseContainer/PauseLabel
@onready var background: ColorRect = $OpacityBackground


func change_lives(new_lives: int) -> void:
	lives_label.text = "Lives: " + str(new_lives)


func change_score(new_score: int) -> void:
	score_label.text = "%06d" % new_score
	

func toggle_double_score(enabled: bool) -> void:
	if enabled:
		double_score_label.show()
		return
	
	double_score_label.hide()




func end_game() -> void:
	background.show()
	high_score_label.text += str(GameManager.score)
	stats.hide()
	game_over_container.show()


func pause_game() -> void:
	background.show()
	pause_label.randomize_goof()
	pause_container.show()


func continue_game() -> void:
	background.hide()
	pause_container.hide()


func _on_try_again_button_pressed() -> void:
	GameManager.restart_game()


func _on_continue_button_pressed() -> void:
	continue_game()
	game_resumed.emit()


func _on_exit_button_pressed() -> void:
	game_quit.emit()
