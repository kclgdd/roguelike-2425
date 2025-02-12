extends Node

@export var hearts : Array[Node]
@onready var collectable_label: Label = %collectableLabel


var max_lives = 3
var lives = max_lives
var collectable = 0

func _ready() -> void:	
	pass	
	
	
func decrease_health():
	lives -= 1;
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
			
func increase_collectable():
	collectable += 1
	collectable_label.text = "Apples: " + str(collectable)
	
