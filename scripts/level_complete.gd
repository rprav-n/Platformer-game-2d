class_name LevelComplete

extends CanvasLayer

func _ready():
	$PanelContainer/MarginContainer/VBoxContainer/Button.connect("pressed", Callable(self, "_on_next_button_pressed"))

func _on_next_button_pressed():
	$"/root/LevelManager".increment_level()
