extends Area2D
@onready var _animated_sprite: Sprite2D = $Sprite2D
@export var _speed: float = 150.0
@export var _patrol_left_node: Node2D
@export var _patrol_right_node: Node2D
var _direction: int = 1

func _ready() -> void:
	set_process(true)

func _physics_process(delta: float) -> void:
	if not _patrol_left_node or not _patrol_right_node:
		return

	var left_x: float = _patrol_left_node.global_position.x
	var right_x: float = _patrol_right_node.global_position.x

	global_position.x += _speed * _direction * delta

	if _direction == 1 and global_position.x >= right_x:
		global_position.x = right_x
		_direction = -1
		_on_direction_changed(-_direction)
	elif _direction == -1 and global_position.x <= left_x:
		global_position.x = left_x
		_direction = 1
		_on_direction_changed(-_direction)

func _on_direction_changed(new_direction: int) -> void:
	_animated_sprite.flip_h = new_direction == -1

func _on_body_entered(body: CharacterBody2D) -> void:
	var direction = sign(body.global_position.x - global_position.x)
	body.hit(direction)
