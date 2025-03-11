extends Node

var cheats_enabled: bool = true
var input_sequence: String = "" # Stores the currently typed sequence

var cheat_codes = {
	"NMNM": "speed_up"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		# Check if Alt is held
		if Input.is_key_pressed(KEY_ALT):
			var key_char = OS.get_keycode_string(event.keycode).to_upper()
			input_sequence += key_char

			# Limit sequence length to avoid unnecessary memory usage
			if input_sequence.length() > 10:
				input_sequence = input_sequence.right(10)

			# Check if the sequence matches any cheat codes
			for cheat in cheat_codes.keys():
				if input_sequence.ends_with(cheat):
					print("Cheat Activated:", cheat_codes[cheat])
					call(cheat_codes[cheat]) 
					input_sequence = "" 
					
		else:
			input_sequence = ""
			
func speed_up():
	var player = get_node_or_null("/root/Node/CharacterBody2D")
	
	if player:
		player.SPEED *= 10
		print(player.SPEED)
