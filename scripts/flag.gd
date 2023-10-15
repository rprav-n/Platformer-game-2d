extends Node2D

signal player_won

func _ready():
	$Area2D.connect("area_entered", Callable(self, "_on_area_entered"))
	
func _on_area_entered(_area: Area2D):
	emit_signal("player_won")
