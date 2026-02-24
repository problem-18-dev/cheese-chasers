extends Node


enum Difficulty { Easy, Hard }

var main_scene: Main

var high_score := 0
var start_lives := 5
var difficulty := Difficulty.Easy

var score := 0
var lives := start_lives

var _save_path := "user://high_score.save"


func _ready() -> void:
	load_high_score()


func take_life() -> void:
	lives -= 1
	

func change_lives(new_lives: int) -> void:
	lives = new_lives


func add_score(new_score: int) -> void:
	score += new_score


func reset_stats() -> void:
	score = 0
	lives = start_lives


func change_difficulty(new_difficulty: Difficulty) -> void:
	difficulty = new_difficulty


func save_high_score():
	if score <= high_score:
		return
	
	var file := FileAccess.open(_save_path, FileAccess.WRITE)
	file.store_var(score)
	

func load_high_score():
	if not FileAccess.file_exists(_save_path):
		print("Save file not found")
		high_score = 0
		return
		
	print("Save file found")
	var file := FileAccess.open(_save_path, FileAccess.READ)
	high_score = file.get_var()


func restart_game() -> void:
	reset_stats()
	main_scene.load_scene(Main.Scene.Game)
