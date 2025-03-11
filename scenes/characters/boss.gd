extends RigidBody2D

@onready var main_character: CharacterBody2D = $"../../CharacterBody2D"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox

var hit_count: int = 0  # Counter to track the number of hits
const MAX_HITS = 50  # Number of hits required to remove the enemy
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
		body.get_pushed_back(x_delta, y_delta)
		GameManager.decrease_health()
	elif body.name.begins_with("Arrow"):  # Check for collision with arrow
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
			
		flip_hitbox()
		

func attack_animation(distance):
	if distance < 200:
		animated_sprite_2d.animation = "attacking"
	else:
		animated_sprite_2d.animation = "moving"
		
func blood_animation():
	var BloodEffect  = preload("res://scenes/objects/blood_animation.tscn")
	var blood_effect = BloodEffect.instantiate()
	get_parent().add_child(blood_effect)
	blood_effect.position = position
	
		
## Checks if hitbox should be enabled
func should_trigger_hitbox():
	if animated_sprite_2d:
		var total_frames = animated_sprite_2d.sprite_frames.get_frame_count("attacking") 
		var current_frame = animated_sprite_2d.frame  
		
		# Enable hitbox in last frames of attacking animation
		if (animated_sprite_2d.get_animation()=="attacking"
		 and current_frame >= total_frames - 2):
			hitbox.enable()
		else:
			hitbox.disable()
	
## Flips hitbox to make sure it matches flipped sprite
func flip_hitbox():
	if animated_sprite_2d.flip_h:
		print("flip")
		if hitbox.position.x >= 0:
			hitbox.position.x *= -1
	else:
		print("no flip")
		if hitbox.position.x <= 0:
			hitbox.position *= -1
			
func _on_animated_sprite_2d_frame_changed() -> void:
	self.should_trigger_hitbox()

			

			
