extends CanvasLayer

func _ready():
	var base_levels: Array[Node] = get_tree().get_nodes_in_group("base_level") 
	
	if base_levels.size() > 0:
		var base_level = base_levels[0] as BaseLevel
		base_level.connect("coin_changed", Callable(self, "_on_coin_changed"))
		

func _on_coin_changed(total_coins: int, collected_coins: int):
	$MarginContainer/HBoxContainer/CoinLabel.text = str(collected_coins, "/", total_coins)
