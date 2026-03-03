extends Node


var _scenes_ready := false

@onready var sfx_bus_index := AudioServer.get_bus_index("SFX")


func _ready() -> void:
	AudioServer.set_bus_mute(sfx_bus_index, true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and _scenes_ready:
		go_to_main_menu()


func go_to_main_menu() -> void:
	AudioServer.set_bus_mute(sfx_bus_index, false)
	GameManager.main_scene.load_scene(Main.Scene.MainMenu)


func _on_preload_scenes_preloaded() -> void:
	_scenes_ready = true
