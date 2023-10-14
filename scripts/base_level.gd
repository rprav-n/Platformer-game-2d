extends Node

var player_scene = preload("res://scenes/player.tscn")
var spawn_postion: Vector2 = Vector2.ZERO
var current_player_node: CharacterBody2D = null

func _ready():
	spawn_postion = $Player.global_position
	register_player($Player)
	
func register_player(player: CharacterBody2D):
	current_player_node = player
	current_player_node.connect("died", Callable(self, "_on_player_died"), CONNECT_DEFERRED)
	
func create_player():
	var player_instance: CharacterBody2D = player_scene.instantiate()
	add_child(player_instance)
	move_child(player_instance, 1)
	
	player_instance.global_position = spawn_postion
		
	register_player(player_instance)
	
func _on_player_died():
	current_player_node.queue_free()
	create_player()
