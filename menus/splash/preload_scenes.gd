extends Node


signal preloaded


func _ready() -> void:
	_preload_scenes()
	preloaded.emit()


func _preload_scenes() -> void:
	await get_tree().process_frame
	
	var children := get_children()
	for child in children:
		child.queue_free()
