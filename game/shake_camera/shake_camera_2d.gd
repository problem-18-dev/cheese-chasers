extends Camera2D

@export var decay := 0.8
@export var max_offset := Vector2(100, 75)
@export var max_roll := 0.1

var _trauma := 0.0
var _trauma_power := 2


func _ready() -> void:
	randomize()


func _process(delta: float) -> void:
	if _trauma:
		_trauma = max(_trauma - decay * delta, 0)
		_shake()


func add_trauma(amount: float) -> void:
	_trauma = min(_trauma + amount, 1.0)


func small_shake() -> void:
	add_trauma(0.25)


func _shake() -> void:
	var amount := pow(_trauma, _trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
