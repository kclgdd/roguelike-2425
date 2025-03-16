extends RigidBody2D

@onready var game_manager: Node = GameManager
@onready var main_character: CharacterBody2D = $"../../CharacterBody2D"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var rigid_body_2d: RigidBody2D = $"."
@onready var hitbox: Area2D = $Hitbox

const MAX_HEALTH = 10  # Max health of enemy
const MOVE_SPEED = 100.0  # Speed at which the enemy moves
var health = MAX_HEALTH		# Current health of enemy, initialised to max health


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_lock_rotation_enabled(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_toward_main_character(delta)
	

func move_toward_main_character(delta: float) -> void:
	if main_character:
		var direction = (main_character.position - position).normalized()
		linear_velocity = direction * MOVE_SPEED
				
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
	if distance < 140:
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
		if hitbox.position.x >= 0:
			hitbox.position.x *= -1
	else:
		if hitbox.position.x <= 0:
			hitbox.position *= -1
	
func _on_animated_sprite_2d_frame_changed() -> void:
	self.should_trigger_hitbox()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	take_damage(1)
	
func take_damage(damage):
	health -= damage
	if health <= 0:
		blood_animation()
		get_node("/root/AudioManager").play_dead_goblin_sfx()
		queue_free()
