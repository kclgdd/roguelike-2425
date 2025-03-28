extends Area2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_rest()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if (body.name == "CharacterBody2D"):
		get_node("/root/AudioManager").play_yummy_voice()
		queue_free()
		GameManager.restore_full_hp()
