extends CharacterBody2D

const SPEED = 800.0
const JUMP_VELOCITY = -1200.0

const COYOTE_TIME = 0.12
const JUMP_BUFFER_TIME = 0.1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer -= delta

	if can_jump():
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0.0
		jump_buffer_timer = 0.0

	if not is_on_floor():
		velocity += (get_gravity() * 3) * delta

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	play_animation()
	rotate_sprite(direction)

func can_jump() -> bool:
	var coyote_ok = coyote_timer > 0.0
	var buffer_ok = jump_buffer_timer > 0.0
	return coyote_ok and buffer_ok

func play_animation() -> void:
	if(velocity.y != 0):
		animated_sprite.play("jump")
		return
	elif(velocity.x != 0):
		animated_sprite.play("walk")
		return
	else:
		animated_sprite.play("idle")
		return   
		
func rotate_sprite(direction: float) -> void:
	if(direction > 0):
		animated_sprite.scale.x = 1
	elif(direction < 0):
		animated_sprite.scale.x = -1
