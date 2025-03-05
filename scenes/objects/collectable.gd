extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if (body.name == "CharacterBody2D"):
		queue_free()
		GameManager.increase_collectable()
