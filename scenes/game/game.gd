extends Node


@export_category("Level")
@export var start_mice := 3
@export var start_mice_scale := 3

var game_started := false
var _double_score := false

@onready var _mouse_scene: PackedScene = load("res://scenes/mouse/mouse.tscn")
@onready var spawn_location: PathFollow2D = $MouseSpawnPath/MouseSpawnLocation
@onready var hud: CanvasLayer = $HUD
@onready var shake_camera_2d: Camera2D = $ShakeCamera2D
@onready var mice: Node = $GameObjects/Mice
@onready var player: RigidBody2D = $GameObjects/Player
@onready var cheese_hunters_manager: Node = $GameObjects/CheeseHuntersManager
@onready var _total_mice_to_spawn := start_mice


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_pause_game(not get_tree().paused)


func start_game() -> void:
	game_started = true
	hud.show()
	
	if GameManager.is_difficult():
		_total_mice_to_spawn += 1
		
	_spawn_wave()
	player.allow_movement()


func _end_game() -> void:
	hud.end_game()
	cheese_hunters_manager.stop()


func _pause_game(should_pause := true) -> void:
	if should_pause:
		hud.pause_game()
	else:
		hud.continue_game()
	
	get_tree().paused = should_pause


func _spawn_wave() -> void:
	for i in _total_mice_to_spawn:
		# Position
		spawn_location.progress_ratio = randf()
		var position := spawn_location.position
		
		# Direction
		var direction_rotation = spawn_location.rotation + PI / 2
		direction_rotation += randf_range(-PI / 4, PI / 4)
		var direction := Vector2.UP.rotated(direction_rotation)
		
		# Spawn
		_spawn_mouse(position, direction, start_mice_scale)


func _add_score(score_to_add: int) -> void:
	if not game_started:
		return
		
	if _double_score:
		score_to_add *= 2
	
	GameManager.add_score(score_to_add)
	hud.add_score(score_to_add)


func _spawn_mouse(position: Vector2, direction: Vector2, scale: int) -> void:
	var mouse := _mouse_scene.instantiate()
	mouse.hit.connect(_on_mouse_hit)
	mouse.score_added.connect(_add_score)
	mouse.tree_exited.connect(_on_mouse_died)
	mouse.start(position, direction, scale)
	mice.call_deferred("add_child", mouse)


func _on_mouse_hit(hit_position: Vector2, scale: int, count: int, run_from = null) -> void:
	shake_camera_2d.tremor()
	for i in count:
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
		
		_spawn_mouse(hit_position, spawn_direction, scale - 1)


func _on_mouse_died() -> void:
	var mice_alive := mice.get_child_count()
	if mice_alive <= 0:
		_total_mice_to_spawn += 1
		_spawn_wave()
	

func _on_player_hit() -> void:
	GameManager.take_life()
	hud.change_lives(GameManager.lives)
	
	if GameManager.lives > 0:
		shake_camera_2d.medium_shake()
	
	if GameManager.lives <= 0:
		game_started = false
		shake_camera_2d.large_shake()
		_end_game()


func _on_hud_game_resumed() -> void:
	_pause_game(false)


func _on_hud_game_quit() -> void:
	_pause_game(false)
	GameManager.save_high_score()
	GameManager.reset_stats()
	GameManager.main_scene.load_scene(Main.Scene.MainMenu)


func _on_power_ups_manager_double_score_enabled(duration: float) -> void:
	_double_score = true
	hud.toggle_double_score(true)
	await get_tree().create_timer(duration).timeout
	hud.toggle_double_score(false)
	_double_score = false


func _on_cheese_hunters_manager_score_added(score: int) -> void:
	shake_camera_2d.small_shake()
	_add_score(score)
