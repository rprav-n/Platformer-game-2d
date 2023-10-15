extends CharacterBody2D

enum Direction {RIGHT, LEFT}

@export var start_direction: Direction

const MAX_SPEED: int = 25
const GRAVITY: int = 500
var direction: Vector2 = Vector2.ZERO

func _ready():
	direction = Vector2.RIGHT if start_direction == Direction.RIGHT else Vector2.LEFT
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
