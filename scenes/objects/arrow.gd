extends RigidBody2D

var speed = 600

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Apply an initial velocity to the arrow
	#linear_velocity = Vector2(speed, 0)
	name = "Arrow"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
