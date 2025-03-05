extends Node

var max_lives = 3
var lives = max_lives
var collectable = 0

signal health_changed
signal collectible_changed

func _ready() -> void:
	pass	
	
	
func decrease_health():
	lives -= 1;
	print(lives)
	health_changed.emit()
			
	if (lives == 0):
		get_tree().reload_current_scene()
		restore_full_hp()
			
			
func restore_full_hp():
	lives = max_lives
	health_changed.emit()
		
			
func increase_collectable():
	collectable += 1
	collectible_changed.emit()
