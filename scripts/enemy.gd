class_name Enemy

extends CharacterBody2D

const MAX_SPEED: int = 25
const GRAVITY: int = 500

var direction: Vector2 = Vector2.ZERO
var start_direction: Vector2 = Vector2.RIGHT

func _ready():
	direction = start_direction
	$GoalDetector.connect("area_entered", Callable(self, "_on_goal_entered"))
	$HitboxArea.connect("area_entered", Callable(self, "_on_hitbox_entered"))

func _process(delta: float):
	velocity.x = (direction * MAX_SPEED).x
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	move_and_slide()
	
	$AnimatedSprite2D.flip_h = direction.x> 0

func _on_goal_entered(_area: Area2D):
	direction *= -1

func _on_hitbox_entered(_area: Area2D):
	queue_free()
