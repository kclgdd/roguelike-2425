extends CharacterBody2D

var SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

@export var arrow_scene: PackedScene
@onready var weapon_cooldown: Timer = $WeaponCooldown # Minimum time before being able to fire another arrow

@onready var sfx_arrows: AudioStreamPlayer = $"../sfx_arrows"

var push_velocity: Vector2 = Vector2.ZERO
var push_decay: float = 0.9

func get_pushed_back(x, y):
	push_velocity = Vector2(x, y).normalized() * 1000  # Apply push
	
	
func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("left", "right")
	var direction_y := Input.get_axis("up", "down")
	var direction := Vector2(direction_x, direction_y).normalized()
	#print("x: " + str(direction_x) + " y: " + str(direction_y))
	
	# Animations	
	if Input.is_action_pressed("shoot_up") or \
	   Input.is_action_pressed("shoot_down") or \
	   Input.is_action_pressed("shoot_left") or \
	   Input.is_action_pressed("shoot_right"):
		if can_shoot_weapon():
			shoot_arrow()
	elif (velocity.x > 1 || velocity.x < -1 || velocity.y > 1 || velocity.y < -1):
		sprite_2d.animation = "moving"
		if direction_x < 0:
			sprite_2d.flip_h = true  # Face left
		elif direction_x > 0:
			sprite_2d.flip_h = false  # Face right
	else:
		sprite_2d.animation = "default"

	# If being pushed
	if push_velocity.length() > 10:
		velocity = push_velocity
		push_velocity = lerp(push_velocity, Vector2.ZERO, 1 - pow(push_decay, delta * 60))  # Smooth decay
	else:
		push_velocity = Vector2.ZERO
		velocity = direction * SPEED  # Apply normal movement
	move_and_slide()
		
	
func shoot_arrow() -> void:
	var direction = Vector2.ZERO
	# Check for arrow key inputs and allow diagonal combinations
	if Input.is_action_pressed("shoot_up"):
		direction.y -= 1
	if Input.is_action_pressed("shoot_down"):
		direction.y += 1
	if Input.is_action_pressed("shoot_left"):
		direction.x -= 1
	if Input.is_action_pressed("shoot_right"):
		direction.x += 1

	# If no direction is pressed, don't shoot
	if direction == Vector2.ZERO:
		return
		
	# Normalize direction so diagonal speed is the same as horizontal/vertical
	direction = direction.normalized()
	
	var arrow_instance = create_arrow(direction)
	get_parent().add_child(arrow_instance)
	
	weapon_cooldown.start()
	
	AudioManager.play_arrow_sfx()
	sprite_2d.animation = "shooting"
	if direction.x < 0:
		sprite_2d.flip_h = true  # Face left
	elif direction.x > 0:
		sprite_2d.flip_h = false

func create_arrow(direction: Vector2) -> Node2D:
	var arrow_instance = arrow_scene.instantiate()
	arrow_instance.position = position + (direction * 70)  # Offset spawn position
	arrow_instance.linear_velocity = direction * 2000  # Set velocity
	arrow_instance.rotation = direction.angle()  # Rotate arrow to match direction

	return arrow_instance

func take_damage():
	# Only take damage if not being pushed back
	if push_velocity == Vector2.ZERO:
		GameManager.decrease_health()
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()
	self.take_damage()
	
	# Push back
	if enemy and push_velocity == Vector2.ZERO:
		var x_delta = position.x - enemy.position.x
		var y_delta = enemy.position.y - position.y
		get_pushed_back(x_delta, y_delta)
		

func can_shoot_weapon():
	return weapon_cooldown.is_stopped()

	
