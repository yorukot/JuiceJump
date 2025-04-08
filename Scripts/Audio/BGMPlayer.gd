extends AudioStreamPlayer2D

func _ready():
	# Set initial volume
	volume_db = -10.0  # Increased from -20.0 to be more audible
	
	# Ensure the stream is loaded
	if not stream:
		stream = load("res://Asset/Audio/BGM.wav")
	
	# Start playing
	play()
	
	# Connect to the finished signal to loop the music
	finished.connect(_on_finished)

func _on_finished():
	# Restart the music when it finishes
	play() 
