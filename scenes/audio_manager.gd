extends Node
@onready var arrows_sfx: AudioStreamPlayer = $sfx_arrows
@onready var background_music = AudioStreamPlayer
@onready var dead_goblin_scream_voice = AudioStreamPlayer
@onready var blood_explosion_sfx = AudioStreamPlayer
@onready var yummy_voice = AudioStreamPlayer


func _ready() -> void:
	background_music = AudioStreamPlayer.new()
	add_child(background_music)
	background_music.stream = preload("res://sound/music/funny_battle_music.mp3")  
	background_music.play()
	
	arrows_sfx = AudioStreamPlayer.new()
	add_child(arrows_sfx)
	arrows_sfx.stream = preload("res://sound/sfx/arrows.mp3")
	
	yummy_voice = AudioStreamPlayer.new()
	add_child(yummy_voice)
	yummy_voice.stream = preload("res://sound/sfx/yummy_voice.mp3")
	
	blood_explosion_sfx = AudioStreamPlayer.new()
	add_child(blood_explosion_sfx)
	blood_explosion_sfx.stream = preload("res://sound/sfx/blood_explosion_sfx.mp3")
	
	dead_goblin_scream_voice = AudioStreamPlayer.new()
	add_child(dead_goblin_scream_voice)
	dead_goblin_scream_voice.stream = preload("res://sound/sfx/dead_goblin_scream_voice.mp3")
	
func play_arrow_sfx():
	if arrows_sfx.stream:
		arrows_sfx.play()
		
func play_yummy_voice():
	if yummy_voice.stream:
		yummy_voice.play()
		
func play_dead_goblin_sfx():
	if dead_goblin_scream_voice.stream:
		dead_goblin_scream_voice.play()
	if blood_explosion_sfx.stream:
		blood_explosion_sfx.play()
		
func set_volume(volume_db: float):
	background_music.volume_db = volume_db

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
