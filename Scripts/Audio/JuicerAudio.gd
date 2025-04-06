extends Node

# FIXME: 
# - The start sound and the loop sound are not doing the right thing.

# Preload the audio files
@onready var start_sound = preload("res://Asset/Audio/Juicer/JuicerStart.mp3")
@onready var loop_sound = preload("res://Asset/Audio/Juicer/JuicerLoop.mp3")
@onready var end_sound = preload("res://Asset/Audio/Juicer/JuicerEnd.mp3")

# Set up audio players for each part of the sequence
@onready var start_player = $StartPlayer
@onready var loop_player = $LoopPlayer
@onready var end_player = $EndPlayer

# Flag to track if we're currently in a sound sequence
var is_playing_sequence = false

# Signal to know when the start sound is finished
signal start_finished
signal end_finished

func _ready():
	# Connect the finished signal of start_player to our method
	start_player.finished.connect(_on_start_player_finished)
	end_player.finished.connect(_on_end_player_finished)
	
	# Set up the audio streams
	start_player.stream = start_sound
	loop_player.stream = loop_sound
	end_player.stream = end_sound
	
	# AudioStreamPlayer doesn't directly support looping for MP3
	# We'll handle this manually with a finished signal connection
	loop_player.finished.connect(_on_loop_player_finished)
	
	print("JuicerAudio: Ready")

# Play the start sound
func play_start():
	print("JuicerAudio: Starting sound sequence")
	
	# Prevent multiple play attempts
	if start_player.playing:
		print("JuicerAudio: Start sound already playing, ignoring")
		return
		
	# Stop other sounds first
	loop_player.stop()
	end_player.stop()

	# Set flag
	is_playing_sequence = true
	
	# Play the start sound
	start_player.play()
	print("JuicerAudio: Start sound playing")

# Play the loop sound
func play_loop():
	if not loop_player.playing:
		loop_player.play()
		print("JuicerAudio: Loop sound started")

# Restart the loop when it finishes
func _on_loop_player_finished():
	# Only restart if we're not playing the end sound
	if not end_player.playing and is_playing_sequence:
		loop_player.play()
		print("JuicerAudio: Loop sound restarted")

# Play the end sound
func play_end():
	print("JuicerAudio: Ending sound sequence")
	
	# Stop the loop sound
	loop_player.stop()
	
	# Play the end sound only if not already playing
	if not end_player.playing:
		end_player.play()
		print("JuicerAudio: End sound playing")
	
# Stop all sounds
func stop_all():
	if start_player.playing or loop_player.playing or end_player.playing:
		print("JuicerAudio: Stopping all sounds")
		start_player.stop()
		loop_player.stop()
		end_player.stop()
		is_playing_sequence = false

# Called when the start sound finishes
func _on_start_player_finished():
	print("JuicerAudio: Start sound finished")
	
	# Emit the signal
	emit_signal("start_finished")
	
	# Start the loop sound if we're still in sequence
	if is_playing_sequence:
		play_loop()
	
# Called when the end sound finishes
func _on_end_player_finished():
	print("JuicerAudio: End sound finished")
	
	# Emit the signal
	emit_signal("end_finished")
	
	# Reset flag
	is_playing_sequence = false 