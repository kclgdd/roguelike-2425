extends Node

@export var hearts : Array[Node]

var max_lives = 3
var lives = max_lives

func _ready() -> void:
	print(lives)		
	
func decrease_health():
	lives -= 1;
	print(lives)
	
	update_hearts_display()
			
	if (lives == 0):
		get_tree().reload_current_scene()
			
func restore_full_hp():
	lives = max_lives
	update_hearts_display()
		
func update_hearts_display():
	for h in range(max_lives):
		if h < lives:
			hearts[h].show()
		else:
			hearts[h].hide()
