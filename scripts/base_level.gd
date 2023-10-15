class_name  BaseLevel
extends Node

signal coin_changed

@export var level_complete_scene: PackedScene

var player_scene = preload("res://scenes/player.tscn")
var spawn_postion: Vector2 = Vector2.ZERO
var current_player_node: CharacterBody2D = null
var total_coins: int = 0
var collected_coins: int = 0

func _ready():
	spawn_postion = $PlayerRoot/Player.global_position
	register_player($PlayerRoot/Player)
	coin_total_change(get_tree().get_nodes_in_group("coin").size())
	
	$Flag.connect("player_won", Callable(self, "_on_player_won"))
	
func register_player(player: CharacterBody2D):
	current_player_node = player
	current_player_node.connect("died", Callable(self, "_on_player_died"), CONNECT_DEFERRED)
	
func create_player():
	var player_instance: CharacterBody2D = player_scene.instantiate()
	$PlayerRoot.add_child(player_instance)
	
	player_instance.global_position = spawn_postion
		
	register_player(player_instance)
	
func _on_player_died():
	current_player_node.queue_free()
	
	var timer = get_tree().create_timer(1)
	await timer.timeout
	create_player()

func coin_collected():
	collected_coins += 1
	print(total_coins, collected_coins)
	emit_signal("coin_changed", total_coins, collected_coins)
	
func coin_total_change(new_total: int):
	total_coins = new_total
	emit_signal("coin_changed", total_coins, collected_coins)

func _on_player_won():
	current_player_node.queue_free()
	var level_complete = level_complete_scene.instantiate()
	add_child(level_complete)
