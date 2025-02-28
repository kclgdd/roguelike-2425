extends Area2D

# @export var damage := 1 
@onready var collider: CollisionShape2D = $CollisionShape2D  # Assuming it's a direct child

func enable() -> void:
	if collider:
		collider.disabled = false			

func disable() -> void:
	if collider:		
		collider.disabled = true
