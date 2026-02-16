extends Node


func play() -> void:
	var player := AudioStreamPlayer.new()
	player.finished.connect(_on_player_finished.bind(player))
	player.bus = "SFX"
	player.stream = load("")
	player.autoplay = true
	add_child(player)
	

func _on_player_finished(player: AudioStreamPlayer) -> void:
	player.queue_free()
