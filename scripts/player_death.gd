class_name PlayerDeath

extends CharacterBody2D

func _process(delta):
	move_and_slide()
	
	if is_on_floor():
		velocity = lerp(Vector2.ZERO, velocity, pow(2, -10 * delta))
