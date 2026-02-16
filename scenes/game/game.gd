extends Node


@export_category("Level")
@export var start_mice := 3
@export var start_mice_scale := 3

var game_started := false
var _score := 0

@onready var _mouse_scene: PackedScene = load("res://scenes/mouse/mouse.tscn")
@onready var spawn_location: PathFollow2D = $SpawnPath/SpawnLocation
@onready var hud: CanvasLayer = $HUD
@onready var shake_camera_2d: Camera2D = $ShakeCamera2D
@onready var mice: Node = $GameObjects/Mice
@onready var player: RigidBody2D = $GameObjects/Player


@onready var _total_mice := start_mice


func _process(_delta: float) -> void:
	if not game_started:
		return
	
	var mice_in_game := mice.get_child_count()
	if mice_in_game <= 0:
		_total_mice += 1
		_spawn_mice()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_pause_game(not get_tree().paused)


func start_game() -> void:
	hud.show()
	if GameManager.difficulty == GameManager.Difficulty.Hard:
		_total_mice += 1
	_spawn_mice()
	player.allow_movement();
	game_started = true


func _end_game() -> void:
	GameManager.save_high_score()
	hud.end_game()


func _pause_game(should_pause := true) -> void:
	if should_pause:
		hud.pause_game()
	else:
		hud.continue_game()
		
	get_tree().paused = should_pause


func _spawn_mice() -> void:
	for i in _total_mice:
		var mouse := _mouse_scene.instantiate()
		
		# Position
		spawn_location.progress_ratio = randf()
		var position := spawn_location.position
		
		# Direction
		var direction_rotation = spawn_location.rotation + PI / 2
		direction_rotation += randf_range(-PI / 4, PI / 4)
		var direction := Vector2.RIGHT.rotated(direction_rotation)
		
		# Spawn
		mouse.hit.connect(_on_mouse_hit)
		mouse.score_added.connect(_add_score)
		mouse.start(position, direction, start_mice_scale)
		mice.add_child(mouse)


func _add_score(score_to_add: int) -> void:
	_score += score_to_add
	GameManager.add_score(score_to_add)
	hud.change_score(GameManager.score)


func _on_mouse_hit(hit_position: Vector2, scale: int, count: int, run_from = null) -> void:
	for i in count:
		var mouse := _mouse_scene.instantiate()
		
		# Run away from player, else random direction
		var spawn_rotation: float
		var spawn_direction: Vector2
		if run_from:
			spawn_rotation = randf_range(-PI / 4, PI / 4)
			var direction_to_player := hit_position.direction_to(run_from)
			spawn_direction = direction_to_player.rotated(PI + spawn_rotation)
		else:
			spawn_rotation = randf_range(-PI,  PI)
			spawn_direction = Vector2.UP.rotated(spawn_rotation)
		
		mouse.hit.connect(_on_mouse_hit)
		mouse.score_added.connect(_add_score)
		mouse.start(hit_position, spawn_direction, scale - 1)
		mice.call_deferred("add_child", mouse)


func _on_player_hit() -> void:
	GameManager.take_life()
	hud.change_lives(GameManager.lives)
	shake_camera_2d.small_shake()
	
	if GameManager.lives <= 0:
		_end_game()


func _on_hud_game_resumed() -> void:
	_pause_game(false)


func _on_hud_game_quit() -> void:
	_pause_game(false)
	GameManager.save_high_score()
	GameManager.main_scene.load_scene(Main.Scene.MainMenu)


func _on_power_up_timer_timeout() -> void:
	pass
