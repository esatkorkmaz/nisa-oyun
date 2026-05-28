extends AnimatedSprite2D

@onready var _controller: CharacterBody2D = get_parent()

@export var _hurt_color: Color = Color.RED

func _process(delta: float) -> void:
	var direction := Input.get_axis('move_left', 'move_right')
	
	_play_animation()
	_rotate_sprite(-_controller.hit_direction if _controller.been_hit else (direction if _controller.input_enabled else 0.0))

func _play_animation() -> void:
	var animation_to_play: String
	
	if _controller.been_hit:
		animation_to_play = 'hurt'
	elif _controller.is_on_ladder:
		animation_to_play = 'climb'
	elif _controller.velocity.y != 0:
		animation_to_play = 'jump' 
	elif _controller.velocity.x != 0:
		animation_to_play = 'walk' 
	else:
		animation_to_play = 'idle' 
	
	if animation == animation_to_play:
		return
	
	play(animation_to_play)
	
	if animation_to_play == 'hurt':
		_hurt_effect()

func _rotate_sprite(direction: float) -> void:
	if direction > 0:
		scale.x = 1
	elif direction < 0:
		scale.x = -1

func _hurt_effect() -> void:
	modulate = _hurt_color
	await get_tree().create_timer(0.5).timeout
	modulate = Color.WHITE
