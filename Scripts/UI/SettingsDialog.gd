extends Control

func _ready():
	# Initially hide the settings dialog
	visible = false
	
	# Connect close button
	$Panel/VBoxContainer/CloseButton.pressed.connect(close_settings)
	
	# Connect volume slider
	$Panel/VBoxContainer/VolumeContainer/VolumeSlider.value_changed.connect(adjust_volume)

func close_settings():
	# Hide the settings dialog
	visible = false

func adjust_volume(value):
	# Get the audio bus index for the master bus
	var master_bus = AudioServer.get_bus_index("Master")
	
	# Convert the slider value (0-100) to decibels (-80 to 0)
	var db_value = linear_to_db(value / 100.0)
	
	# Set the volume of the master bus
	AudioServer.set_bus_volume_db(master_bus, db_value)
