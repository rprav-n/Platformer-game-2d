extends CharacterBody2D

const GRAVITY: int = 1000
const MAX_HORIZONTAL_SPEED: int = 125
const JUMP_SPEED: int = 350
const HORIZONTAL_ACCELERATION: int = 1800
const JUMP_TERMINATION_MULTIPLIER: int = 4

func _ready():
	pass
	
func _process(delta: float):
	
	var move_vector: Vector2 = get_movement_vector()
	
	velocity.x += move_vector.x * HORIZONTAL_ACCELERATION * delta
	if move_vector.x == 0:
		#velocity.x = lerp(velocity.x, 0.0, 0.1)
		velocity.x = lerp(0.0, velocity.x, pow(2, -40 * delta))
	
	velocity.x = clamp(velocity.x, -MAX_HORIZONTAL_SPEED, MAX_HORIZONTAL_SPEED)
	
	if move_vector.y < 0 && is_on_floor():
		velocity.y = move_vector.y * JUMP_SPEED
	
	if velocity.y < 0 && !Input.is_action_pressed("jump"):
		velocity.y += GRAVITY * JUMP_TERMINATION_MULTIPLIER * delta
	else:
		velocity.y += GRAVITY * delta
	
	move_and_slide()

func get_movement_vector() -> Vector2:
	var move_vector: Vector2 = Vector2.ZERO
	move_vector.x = Input.get_axis("move_left", "move_right")
	move_vector.y = -1 if Input.is_action_just_pressed("jump") else 0
	
	return move_vector
