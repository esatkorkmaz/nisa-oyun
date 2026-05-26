extends Camera2D

@onready var _controller: CharacterBody2D = get_parent()

func _ready() -> void:
	_controller.on_player_been_hit.connect(_on_player_been_hit)

func _on_player_been_hit(knockback: bool) -> void:
		position_smoothing_speed = 10 if _controller.been_hit && !knockback else 5
