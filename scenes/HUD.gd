extends Control

@onready var canvas_layer = $Canvas
@export var hearts : Array[Node]
@export var collectable_label: Label

func _ready():
	update_hearts_display()
	GameManager.connect("health_changed", update_hearts_display)
	
	collectable_label.text = "Apples: 0"
	GameManager.connect("collectible_changed", update_collectible_display)
	
func hide_hud():
	canvas_layer.visible = false

# Method to show the HUD
func show_hud():
	canvas_layer.visible = true
			
func update_hearts_display():
	for h in range(len(hearts)):
		if h < GameManager.lives:
			hearts[h].show()
		else:
			hearts[h].hide()
	
func update_collectible_display():
	collectable_label.text = "Apples: " + str(GameManager.collectable)
	
