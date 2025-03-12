extends Control

@onready var canvas_layer = $Canvas
@export var hearts : Array[Node]
@export var collectable_label: Label
@onready var timer_label: Label = $Canvas/TimerLabel
@onready var timer: Timer = $Timer

var elapsed_time: float = 0.0

func _ready():
	update_hearts_display()
	GameManager.connect("health_changed", update_hearts_display)
	
	collectable_label.text = "Apples: 0"
	GameManager.connect("collectible_changed", update_collectible_display)

	# Set up the timer
	timer.wait_time = 1.0 
	timer.one_shot = false
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

	timer_label.text = "00:00"

func hide_hud():
	canvas_layer.visible = false

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

func _on_timer_timeout():
	elapsed_time += 1.0  
	timer_label.text = format_time(elapsed_time)

func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]
