extends CharacterBody2D

const _SPEED: float = 800.0

const _JUMP_VELOCITY: float = -1200.0
const _HIT_VELOCITY: float = -1200.0

const _COYOTE_TIME: float = 0.12
const _JUMP_BUFFER_TIME: float = 0.1

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0.0

var _input_enabled: bool = true
var _been_hit: bool = false

var _hit_direction: float = -1.0

func _physics_process(delta: float) -> void:
	if is_on_floor():
		if(_been_hit):
			_been_hit = false
			_input_enabled = true
		
		_coyote_timer = _COYOTE_TIME
	else:
		_coyote_timer -= delta
		
	if Input.is_action_just_pressed("jump"):
		hit(_hit_direction)

	#if Input.is_action_just_pressed("jump"):
	#	jump_buffer_timer = JUMP_BUFFER_TIME
	#else:
	#	jump_buffer_timer -= delta

	if _can_jump() && _input_enabled:
		velocity.y = _JUMP_VELOCITY
		_coyote_timer = 0.0
		_jump_buffer_timer = 0.0

	if not is_on_floor():
		velocity += (get_gravity() * 3) * delta
		
	var direction := Input.get_axis("move_left", "move_right")
		
	if _input_enabled:
		if direction && _input_enabled:
			velocity.x = direction * _SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, _SPEED)

	move_and_slide()
	_play_animation()
	_rotate_sprite(-_hit_direction if _been_hit else (direction if _input_enabled else 0.0))
	
func hit(direction: float) -> void:
	_input_enabled = false
	_been_hit = true
	
	velocity.x = _HIT_VELOCITY / 3 * (-1 if direction > 0 else 1)
	velocity.y = _HIT_VELOCITY
	

func _can_jump() -> bool:
	var coyote_ok = _coyote_timer > 0.0
	var buffer_ok = _jump_buffer_timer > 0.0
	return coyote_ok and buffer_ok

func _play_animation() -> void:
	if(_been_hit):
		_animated_sprite.play("hurt")
		return

	if(velocity.y != 0):
		_animated_sprite.play("jump")
		return
	elif(velocity.x != 0):
		_animated_sprite.play("walk")
		return
	else:
		_animated_sprite.play("idle")
		return   
		
func _rotate_sprite(direction: float) -> void:
	if(direction > 0):
		_animated_sprite.scale.x = 1
	elif(direction < 0):
		_animated_sprite.scale.x = -1
