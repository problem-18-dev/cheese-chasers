extends Node


enum Difficulty { Easy, Hard }

const SAVE_PATH := "user://high_score.tres"
const START_LIVES := 5

var main_scene: Main
var save_game: HighScoreSave

var high_score := 0
var difficulty := Difficulty.Easy

var score := 0
var lives := START_LIVES


func _ready() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		save_game = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
		return
	
	save_game = HighScoreSave.new()


func take_life() -> void:
	lives -= 1
	

func change_lives(new_lives: int) -> void:
	lives = new_lives


func add_score(new_score: int) -> void:
	score += new_score


func reset_stats() -> void:
	score = 0
	lives = START_LIVES


func change_difficulty(new_difficulty: Difficulty) -> void:
	difficulty = new_difficulty
	

func is_difficult() -> bool:
	return difficulty == Difficulty.Hard


func save_high_score() -> void:
	if score <= 0:
		return
	
	var scores := save_game.high_scores.duplicate()
	scores.append(score)
	scores.sort()
	scores.reverse()
	save_game.high_scores = scores.slice(0, 3)
	ResourceSaver.save(save_game, SAVE_PATH)


func restart_game() -> void:
	save_high_score()
	reset_stats()
	main_scene.load_scene(Main.Scene.Game)
