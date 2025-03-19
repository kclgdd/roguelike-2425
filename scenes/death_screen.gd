extends Node

func _ready():
	Hud.hide_hud()
	$RetryButton.connect("pressed", _on_retry_pressed)
	$MainMenuButton.connect("pressed", on_main_menu_pressed)
	
func _on_retry_pressed():
	get_tree().change_scene_to_file("res://scenes/areas/main.tscn")
	GameManager.reset()
	Hud.reset()
	Hud.show_hud()

func on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	GameManager.reset()
	Hud.reset()
