extends Node


enum SFX { 
	# Player
	PlayerShoot,
	PlayerBump,
	PlayerExplode,
	
	# Powerup
	PowerUp,
	
	# Mouse
	MouseDeath,
	
	# Hunter
	HunterShoot,
	HunterDeath,
	
	# GUI
	Hover,
	Press
	}

var _sound_effects := {
	# Player
	SFX.PlayerShoot: "res://assets/sfx/player_shoot.ogg",
	SFX.PlayerBump: "res://assets/sfx/player_bump.ogg",
	SFX.PlayerExplode: "res://assets/sfx/player_explode.ogg",
	
	# Powerup
	SFX.PowerUp: "res://assets/sfx/powerup.ogg",
	
	# Mouse
	SFX.MouseDeath: "res://assets/sfx/mouse_death.ogg",
	
	# Hunter
	SFX.HunterShoot: "res://assets/sfx/player_shoot.ogg",
	SFX.HunterDeath: "res://assets/sfx/mouse_death.ogg",
	
	# GUI
	SFX.Hover: "res://assets/sfx/gui_hover.ogg",
	SFX.Press: "res://assets/sfx/gui_press.ogg"
}


func play(sfx_name: SFX, pitch_scale := randf_range(0.95, 1.05)) -> void:
	var player := AudioStreamPlayer.new()
	player.finished.connect(_on_player_finished.bind(player))
	player.bus = "SFX"
	player.pitch_scale = pitch_scale
	player.stream = load(_sound_effects[sfx_name])
	player.autoplay = true
	add_child(player)
	

func _on_player_finished(player: AudioStreamPlayer) -> void:
	player.queue_free()
