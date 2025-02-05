extends Area2D

@onready var game_manager: Node = %GameManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if (body.name == "CharacterBody2D"):
		get_node("/root/AudioManager").play_yummy_voice()
		queue_free()
		game_manager.restore_full_hp()
