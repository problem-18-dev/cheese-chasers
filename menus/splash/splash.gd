extends Node


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		go_to_main_menu()


func go_to_main_menu() -> void:
	GameManager.main_scene.load_scene(Main.Scene.MainMenu)
