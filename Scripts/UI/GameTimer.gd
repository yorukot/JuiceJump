extends CanvasLayer

# Time values
var start_time = 0
var current_time = 0
var is_running = false

# Called when the node enters the scene tree for the first time
func _ready():
	# Set font for the timer label
	$TimerLabel.add_theme_font_override("font", load("res://Asset/font/minecraft_font.ttf"))
	# Position the timer at the top right
	var viewport_size = get_viewport().get_visible_rect().size
	$TimerLabel.position = Vector2(viewport_size.x - $TimerLabel.size.x - 20, 20)
	$TimerLabel.text = "00:00:00"
	
	# Auto-start the timer when the game loads
	start_timer()
	print("Timer started automatically")

# Start the timer when called
func start_timer():
	start_time = Time.get_ticks_msec()
	is_running = true

# Stop the timer when called
func stop_timer():
	is_running = false
	return format_time(current_time)

# Reset the timer to 0
func reset_timer():
	start_time = Time.get_ticks_msec()
	current_time = 0
	$TimerLabel.text = "00:00:00"

# Format milliseconds to HH:MM:SS
func format_time(time_ms):
	var seconds = int(time_ms / 1000) % 60
	var minutes = int(time_ms / 60000) % 60
	var hours = int(time_ms / 3600000)
	
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

# Process function to update the timer
func _process(_delta):
	if is_running:
		current_time = Time.get_ticks_msec() - start_time
		$TimerLabel.text = format_time(current_time)