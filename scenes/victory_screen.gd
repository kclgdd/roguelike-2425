extends Node

func _ready():
	Hud.hide_hud()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	GameManager.reset()
	Hud.reset()
