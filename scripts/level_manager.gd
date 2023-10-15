extends Node

var levelScenes: Array[PackedScene] = [
	preload("res://scenes/levels/level_001.tscn"),
	preload("res://scenes/levels/level_002.tscn"),
]

var current_level_index: int = 0


func change_level(level_index: int):
	current_level_index = level_index
	if current_level_index >= levelScenes.size():
		current_level_index = 0
		
	var level_scene = levelScenes[current_level_index] as PackedScene
	get_tree().change_scene_to_packed(level_scene)	

func increment_level():
	change_level(current_level_index + 1)
