extends CharacterBody2D

const _COYOTE_TIME: float = 0.12
const _JUMP_BUFFER_TIME: float = 0.1

@export var _speed: float = 800.0

@export var _jump_velocity: float = -1200.0
@export var _hit_velocity: float = -1200.0

var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0.0
var _hit_timer: float = 0.0

var input_enabled: bool = true
var been_hit: bool = false

var hit_direction: float = -1.0

func _physics_process(delta: float) -> void:
	if been_hit: 
		_hit_timer -= delta
	
	if is_on_floor():
		if(been_hit && _hit_timer < 0.0):
			been_hit = false
			input_enabled = true
		
		_coyote_timer = _COYOTE_TIME
	else:
		_coyote_timer -= delta
	
	if Input.is_action_just_pressed('jump'):
		_jump_buffer_timer = _JUMP_BUFFER_TIME
	else:
		_jump_buffer_timer -= delta

	if _can_jump() && input_enabled:
		velocity.y = _jump_velocity
		_coyote_timer = 0.0
		_jump_buffer_timer = 0.0
	
	if not is_on_floor():
		velocity += (get_gravity() * 3) * delta
	
	var direction := Input.get_axis('move_left', 'move_right')
	
	if input_enabled:
		if direction:
			velocity.x = direction * _speed
		else:
			velocity.x = move_toward(velocity.x, 0, _speed)
	
	move_and_slide()
	
func hit(knockback: bool, direction: float = 0) -> void:
	if been_hit:
		return
	
	if knockback:
		velocity.y = _hit_velocity
		velocity.x = _hit_velocity / 3 * (-1 if direction > 0 else 1)
	
		input_enabled = false
		_hit_timer = 0.05
	
	been_hit = true
	
	%GameManager.lose_life()

func _can_jump() -> bool:
	var coyote_ok = _coyote_timer > 0.0
	var buffer_ok = _jump_buffer_timer > 0.0
	return coyote_ok and buffer_ok
