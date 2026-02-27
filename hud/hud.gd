extends CanvasLayer


signal game_resumed
signal game_quit

var _double_score := false 

@onready var stats: Control = $MarginContainer/Stats
@onready var lives_container: HBoxContainer = $MarginContainer/Stats/LivesContainer
@onready var score_container: HBoxContainer = $MarginContainer/Stats/ScoreContainer
@onready var score_label: Label = $MarginContainer/Stats/ScoreContainer/ScoreLabel
@onready var double_score_label: Label = $MarginContainer/Stats/ScoreContainer/DoubleScoreLabel
@onready var game_over_container: VBoxContainer = $GameOverContainer
@onready var high_score_label: Label = $GameOverContainer/HighScoreLabel
@onready var pause_container: VBoxContainer = $PauseContainer
@onready var pause_label: Label = $PauseContainer/PauseLabel
@onready var background: ColorRect = $OpacityBackground


func change_lives(new_lives: int) -> void:
	var lives := lives_container.get_children()
	for i in lives.size():
		lives[i].visible = i < new_lives


func add_score(score_to_add: int) -> void:
	_change_score()
	_tween_score(score_to_add)


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


func toggle_double_score(enabled: bool) -> void:
	double_score_label.visible = enabled
	_double_score = enabled


func _change_score() -> void:
	score_label.text = "%06d" % GameManager.score


func _tween_score(score_to_add: int) -> void:
	var tween_label := Label.new()
	tween_label.position = score_container.position
	tween_label.size = score_container.size
	tween_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	tween_label.text = "+" + str(score_to_add)
	if _double_score:
		tween_label.add_theme_color_override("font_color", Color(1.0, 0.878, 0.302, 1.0))
	stats.add_child(tween_label)
	
	var final_position := tween_label.position + Vector2(0, 16)
	var tween := create_tween().set_parallel().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(tween_label, "position", final_position, 0.5)
	tween.tween_property(tween_label, "modulate", Color(1.0, 1.0, 1.0, 0.5), 0.5)
	tween.chain().tween_callback(tween_label.queue_free)


func _on_try_again_button_pressed() -> void:
	GameManager.restart_game()


func _on_continue_button_pressed() -> void:
	continue_game()
	game_resumed.emit()


func _on_exit_button_pressed() -> void:
	game_quit.emit()
