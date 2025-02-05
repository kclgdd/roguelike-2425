extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("blood_splash")
	$AnimatedSprite2D.connect("animation_finished", self._on_AnimatedSprite2D_animation_finished)

func _on_AnimatedSprite2D_animation_finished():
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
