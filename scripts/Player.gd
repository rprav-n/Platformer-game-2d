extends CharacterBody2D

signal died

enum State {NORMAL, DASHING}

@export_flags_2d_physics var dash_hazard_mask: int

const GRAVITY: int = 1000
const MAX_HORIZONTAL_SPEED: int = 125
const JUMP_SPEED: int = 300
const HORIZONTAL_ACCELERATION: int = 1800
const JUMP_TERMINATION_MULTIPLIER: int = 4
const MAX_DASH_SPEED: int = 500
const MIN_DASH_SPEED: int = 200

var can_double_jump: bool = false
var can_dash: bool = true
var current_state: State = State.NORMAL
var is_state_new: bool = true
var default_hazard_mask: int = 0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer

func _ready():
	$HazardArea.connect("area_entered", Callable(self, "_on_hazard_area_entered"))
	default_hazard_mask = $HazardArea.collision_mask
	
func _process(delta: float):
	match current_state:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dashing(delta)
	is_state_new = false

func change_state(new_state: State):
	current_state = new_state
	is_state_new = true

func process_normal(delta: float):
	if is_state_new:
		$DashArea/CollisionShape2D.disabled = true
		$HazardArea.collision_mask = default_hazard_mask
	
	var move_vector: Vector2 = get_movement_vector()
	
	velocity.x += move_vector.x * HORIZONTAL_ACCELERATION * delta
	if move_vector.x == 0:
		#velocity.x = lerp(velocity.x, 0.0, 0.1)
		velocity.x = lerp(0.0, velocity.x, pow(2, -40 * delta))
	
	velocity.x = clamp(velocity.x, -MAX_HORIZONTAL_SPEED, MAX_HORIZONTAL_SPEED)
	
	if move_vector.y < 0 && (is_on_floor() || !coyote_timer.is_stopped() || can_double_jump):
		velocity.y = move_vector.y * JUMP_SPEED
		if !is_on_floor() && coyote_timer.is_stopped():
			can_double_jump = false
		coyote_timer.stop()
	
	if velocity.y < 0 && !Input.is_action_pressed("jump"):
		velocity.y += GRAVITY * JUMP_TERMINATION_MULTIPLIER * delta
	else:
		velocity.y += GRAVITY * delta
	
	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
	
	if is_on_floor():
		can_double_jump = true
		can_dash = true
	
	if Input.is_action_just_pressed("dash") && can_dash:
		call_deferred("change_state", State.DASHING)
		can_dash = false
	
	update_animation()

func process_dashing(delta: float):
	if is_state_new:
		$DashArea/CollisionShape2D.disabled = false
		$HazardArea.collision_mask = dash_hazard_mask
		
		animated_sprite.play("jump")
		var move_vector: Vector2 = get_movement_vector()
		var velocity_mod = 1
		if move_vector.x != 0:
			velocity_mod = sign(move_vector.x)
		else:
			velocity_mod = 1 if animated_sprite.flip_h else -1
			
		velocity = Vector2(MAX_DASH_SPEED * velocity_mod, 0)
	
	move_and_slide()
	velocity.x = lerp(0.0, velocity.x, pow(2, -8 * delta))
	
	if abs(velocity.x) < MIN_DASH_SPEED:
		call_deferred("change_state", State.NORMAL)

func get_movement_vector() -> Vector2:
	var move_vector: Vector2 = Vector2.ZERO
	move_vector.x = Input.get_axis("move_left", "move_right")
	move_vector.y = -1 if Input.is_action_just_pressed("jump") else 0
	
	return move_vector


func update_animation():
	var move_vector: Vector2 = get_movement_vector()
	
	if !is_on_floor():
		animated_sprite.play("jump")
	elif move_vector.x !=0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
		
	if move_vector.x != 0:
		animated_sprite.flip_h = move_vector.x > 0


func _on_hazard_area_entered(_area: Area2D):
	emit_signal("died")
	
