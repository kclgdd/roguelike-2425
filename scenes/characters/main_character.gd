extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

@export var arrow_scene: PackedScene

@onready var sfx_arrows: AudioStreamPlayer = $"../sfx_arrows"

@onready var game_manager: Node = %GameManager

var push_velocity: Vector2 = Vector2.ZERO
var push_decay: float = 0.9

func get_pushed_back(x, y):
	push_velocity = Vector2(x, y).normalized() * 1000  # Apply push
	
	
func _physics_process(delta: float) -> void:
	# Animations	
	if Input.is_action_pressed("shoot"):
		sprite_2d.animation = "shooting"
		shoot_arrow()
	elif (velocity.x > 1 || velocity.x < -1 || velocity.y > 1 || velocity.y < -1):
		sprite_2d.animation = "moving"
	else:
		sprite_2d.animation = "default"

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("left", "right")
	var direction_y := Input.get_axis("up", "down")
	var direction := Vector2(direction_x, direction_y).normalized()
	#print("x: " + str(direction_x) + " y: " + str(direction_y))

	# if not being pushec
	if push_velocity.length() > 10:
		velocity = push_velocity
		push_velocity = lerp(push_velocity, Vector2.ZERO, 1 - pow(push_decay, delta * 60))  # Smooth decay
	else:
		push_velocity = Vector2.ZERO
		velocity = direction * SPEED  # Apply normal movement
	move_and_slide()
		
	if direction_x < 0:
		sprite_2d.flip_h = true  # Face left
	elif direction_x > 0:
		sprite_2d.flip_h = false  # Face right
	
func shoot_arrow() -> void:
	var arrow_instance = arrow_scene.instantiate()
	arrow_instance.position = position + Vector2(-70 if sprite_2d.flip_h else 70, 0) # Set the initial position of the arrow to the character's position
	
	get_node("/root/AudioManager").play_arrow_sfx()
	
	# Set the direction and velocity of the arrow
	if sprite_2d.flip_h:
		arrow_instance.linear_velocity  = Vector2(-2000, 0)  
		arrow_instance.get_node("Sprite2D").flip_h = true
	else:
		arrow_instance.linear_velocity  = Vector2(2000, 0)  
		arrow_instance.get_node("Sprite2D").flip_h = false

	get_parent().add_child(arrow_instance)

func take_damage():
	game_manager.decrease_health()
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	self.take_damage()
