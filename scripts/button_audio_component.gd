extends Node


# https://forum.godotengine.org/t/best-proper-way-to-do-ui-sounds-hover-click/39081
func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node: Node) -> void:
	if node is Button:
		node.mouse_entered.connect(_on_hover)
		node.pressed.connect(_on_press)


func _on_hover() -> void:
	AudioManager.play(AudioManager.SFX.Hover)


func _on_press() -> void:
	AudioManager.play(AudioManager.SFX.Press)
