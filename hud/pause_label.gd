extends Label


const PAUSE_GOOFS := ["Was the game too hard?", "Sure, take a breather", "The cheese got smelly..", "Mice are impatient, you know?"]


func randomize_goof() -> void:
	text = PAUSE_GOOFS.pick_random()
