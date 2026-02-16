extends Node


@onready var high_score_label: Label = $UI/MarginContainer/HighScoreLabel
@onready var difficulty_button: Button = $UI/VBoxContainer/DifficultyButton


func _ready() -> void:
	high_score_label.text += str(GameManager.high_score)


func _on_play_button_pressed() -> void:
	GameManager.main_scene.load_scene(Main.Scene.Game)


func _on_difficulty_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameManager.change_difficulty(GameManager.Difficulty.Hard)
		difficulty_button.text = "Hard"
		return
	
	GameManager.change_difficulty(GameManager.Difficulty.Easy)
	difficulty_button.text = "Easy"
