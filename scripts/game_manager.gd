extends Node


var main_scene: Main
var start_lives := 5

var score := 0

var lives := start_lives


func take_life() -> void:
	lives -= 1
	

func change_lives(new_lives: int) -> void:
	lives = new_lives


func add_score(new_score: int) -> void:
	score += new_score
