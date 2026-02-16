class_name Main
extends Node


signal scene_changed(scene: Scene)

enum Scene { MainMenu, Game }

@export_category("Scenes")
@export var first_scene := Scene.Game


var scenes := {
	Scene.MainMenu: "res://menus/main_menu/main_menu.tscn",
	Scene.Game: "res://scenes/game/game.tscn",
}

var current_scene: Node


func _ready() -> void:
	GameManager.main_scene = self
	load_scene(first_scene)


func unload_scene() -> void:
	if current_scene:
		remove_child(current_scene)
		current_scene = null


func load_scene(scene: Scene) -> void:
	unload_scene()
	var new_scene: PackedScene = load(scenes[scene])
	current_scene = new_scene.instantiate()
	add_child(current_scene)
	scene_changed.emit(scene)
