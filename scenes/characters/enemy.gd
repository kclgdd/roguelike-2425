extends RigidBody2D

@onready var game_manager: Node = $"../../GameManager"
@onready var main_character: CharacterBody2D = $"../../CharacterBody2D"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var hit_count: int = 0  # Counter to track the number of hits
const MAX_HITS = 10  # Number of hits required to remove the enemy
const MOVE_SPEED = 100.0  # Speed at which the enemy moves

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_toward_main_character(delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "CharacterBody2D"):
		var x_delta = body.position.x - position.x
		var y_delta = position.y - body.position.y
		print(str(x_delta) + " " + str(y_delta))
		print("lose health")
		body.get_pushed_back(x_delta, y_delta)
		game_manager.decrease_health()
	elif body.name == "Arrow":  # Check for collision with arrow
		hit_count += 1
		print("hit count: " + str(hit_count))
		if hit_count >= MAX_HITS:
			blood_animation()
			get_node("/root/AudioManager").play_dead_goblin_sfx()
			queue_free()
		
func move_toward_main_character(delta: float) -> void:
	if main_character:
		var direction = (main_character.position - position).normalized()
		position += direction * MOVE_SPEED * delta
				
		var distance = main_character.position.distance_to(position)
		
		# Flip the enemy's sprite based on the direction it's moving
		if direction.x < 0:
			animated_sprite_2d.flip_h = true  # Face left
			attack_animation(distance)
		elif direction.x > 0:
			animated_sprite_2d.flip_h = false  # Face right
			attack_animation(distance)
		

func attack_animation(distance):
	if distance < 140:
		animated_sprite_2d.animation = "attacking"
	else:
		animated_sprite_2d.animation = "moving"
		
func blood_animation():
	var BloodEffect  = preload("res://scenes/objects/blood_animation.tscn")
	var blood_effect = BloodEffect.instantiate()
	get_parent().add_child(blood_effect)
	blood_effect.position = position
	
