extends Control

@onready var time_label = $CenterContainer/VBoxContainer/StatsContainer/TimeLabel
@onready var fruits_label = $CenterContainer/VBoxContainer/StatsContainer/FruitsLabel
@onready var restart_button = $CenterContainer/VBoxContainer/ButtonsContainer/RestartButton
@onready var main_menu_button = $CenterContainer/VBoxContainer/ButtonsContainer/MainMenuButton

var game_timer: Node

func _ready():
	# Connect button signals
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	
	# Hide the screen initially
	hide()
	
	# Get reference to the GameTimer
	game_timer = get_node("/root/SpawnPoint/GameTimer")

func show_end_game(total_fruits: int):
	# Stop the game timer and get the final time
	var final_time = game_timer.stop_timer()
	
	# Update the labels with the game stats
	time_label.text = "Total Time: " + final_time
	fruits_label.text = "Total Fruits: " + str(total_fruits)
	
	# Show the screen
	show()

func _on_restart_pressed():
	# Restart the game by reloading the game scene
	get_tree().change_scene_to_file("res://Scenes/SpawnPoint.tscn")

func _on_main_menu_pressed():
	# Return to the main menu
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/LandingPage.tscn") 