extends CanvasLayer

var fruit_count = 0

# Called when the node enters the scene tree for the first time
func _ready():
	# Set font for the fruit counter label
	$FruitLabel.add_theme_font_override("font", load("res://Asset/font/minecraft_font.ttf"))
	# Position the counter at the top left
	$FruitLabel.position = Vector2(60, 20) # Move it right to make room for icon
	update_display()
	
	# We need to wait for the player to be ready before connecting signals
	# Call this after a short delay to ensure all nodes are initialized
	get_tree().create_timer(0.1).timeout.connect(connect_to_player)
	
	print("Fruit counter initialized")

func connect_to_player():
	var players = get_tree().get_nodes_in_group("Player")
	print("Found " + str(players.size()) + " player(s) in the Player group")
	
	for player in players:
		print("Connecting to player at: " + str(player.global_position))
		# Connect using a deferred call to ensure signals propagate correctly
		player.fruit_collected.connect(_on_player_fruit_collected)
		
		# If the player already has collected fruits, update our count
		if player.has_method("get_fruits_collected"):
			fruit_count = player.get_fruits_collected()
			update_display()
			print("Retrieved existing fruit count: " + str(fruit_count))

func _on_player_fruit_collected(points):
	fruit_count += points
	update_display()
	print("Collected fruit! Total: ", fruit_count)

func update_display():
	$FruitLabel.text = str(fruit_count) # Just show the number