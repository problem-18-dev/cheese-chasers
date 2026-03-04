extends Node


@onready var difficulty_button: Button = $UI/Buttons/VBoxContainer/DifficultyButton
@onready var info_score_button: Button = $UI/Buttons/VBoxContainer/InfoScoreButton
@onready var info_score_label: RichTextLabel = $UI/Buttons/InfoScoreLabel



func _ready() -> void:
	if GameManager.save_game.high_scores.size() > 0:
		info_score_button.show()
		info_score_button.button_pressed = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		GameManager.main_scene.load_scene(Main.Scene.Game)


func _on_play_button_pressed() -> void:
	GameManager.main_scene.load_scene(Main.Scene.Game)


func _on_difficulty_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameManager.change_difficulty(GameManager.Difficulty.Hard)
		difficulty_button.text = "Hard"
		return
	
	GameManager.change_difficulty(GameManager.Difficulty.Easy)
	difficulty_button.text = "Easy"


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	$AnimationPlayer.play("chase_loop")


func _on_info_score_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		info_score_button.text = "Scores"
		info_score_label.text = ""
		for i in GameManager.save_game.high_scores.size():
			var score := GameManager.save_game.high_scores[i]
			if i == 0:
				info_score_label.text += "[color=#ffe04d]%s.[/color] %s" % [i + 1, score]
			else:
				info_score_label.text += "\n[color=#ffe04d]%s.[/color] %s" % [i + 1, score]
		return
	
	info_score_button.text = "Controls"
	info_score_label.text = '[color=#ffe04d]ARROWS[/color] to move\n[color=#ffe04d]SPACE[/color] to shoot\n[color=#ffe04d]ESC[/color] to pause'


func _on_problem_18_button_pressed() -> void:
	OS.shell_open("https://problem-18-dev.github.io")
