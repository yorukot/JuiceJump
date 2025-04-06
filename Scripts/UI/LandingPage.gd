extends Control

func _ready():
	# Connect the play button to the start_game function
	$CenterContainer/VBoxContainer/PlayButton.pressed.connect(start_game)
	
	# Connect the settings button to show settings dialog
	$CenterContainer/VBoxContainer/SettingsButton.pressed.connect(show_settings)

func start_game():
	# Change to the main game scene
	get_tree().change_scene_to_file("res://Scenes/SpawnPoint.tscn")

func show_settings():
	# Show the settings dialog
	$SettingsDialog.visible = true