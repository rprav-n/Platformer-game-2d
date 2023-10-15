extends Node2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready():
	$Area2D.connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(_area: Area2D):
	animationPlayer.play("pickup")
	call_deferred("disable_pickup")
	
func disable_pickup():
	$Area2D/CollisionShape2D.disabled = true
