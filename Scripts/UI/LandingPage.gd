extends Control

# Animation variables
var zoom_in = true
var title_scale_min = 0.9
var title_scale_max = 1.1
var animation_speed = 1.0
var title_tween

func _ready():
	# Connect the play button to the start_game function
	$CenterContainer/VBoxContainer/PlayButton.pressed.connect(start_game)
	
	# Connect the settings button to show settings dialog
	$CenterContainer/VBoxContainer/SettingsButton.pressed.connect(show_settings)
	
	# Start the title animation
	start_title_animation()

func start_game():
	# Change to the main game scene
	get_tree().change_scene_to_file("res://Scenes/SpawnPoint.tscn")

func show_settings():
	# Show the settings dialog
	$SettingsDialog.visible = true

func start_title_animation():
	# Get reference to the title text label
	var title_label = $CenterContainer/VBoxContainer/TitleGroup/TitleLabel
	
	# Set initial scale
	title_label.scale = Vector2.ONE
	
	# Create the tween animation
	title_tween = create_tween()
	title_tween.set_ease(Tween.EASE_IN_OUT)
	title_tween.set_trans(Tween.TRANS_SINE)
	
	# Tween to zoomed in scale
	title_tween.tween_property(title_label, "scale", Vector2(title_scale_max, title_scale_max), animation_speed)
	title_tween.tween_property(title_label, "scale", Vector2(title_scale_min, title_scale_min), animation_speed)
	
	# Set the tween to repeat
	title_tween.set_loops()
