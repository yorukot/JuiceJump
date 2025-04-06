extends CanvasLayer

var fruit_count = 0

# Called when the node enters the scene tree for the first time
func _ready():
	# Set font for the fruit counter label
	$FruitLabel.add_theme_font_override("font", load("res://Asset/font/minecraft_font.ttf"))
	# Position the counter at the top right, below the timer
	var viewport_size = get_viewport().get_visible_rect().size
	$FruitLabel.position = Vector2(viewport_size.x - $FruitLabel.size.x - 20, 60)
	update_display()
	
	# Connect to all players in the scene to track fruit collection
	for player in get_tree().get_nodes_in_group("Player"):
		player.fruit_collected.connect(_on_player_fruit_collected)
	
	print("Fruit counter initialized")

func _on_player_fruit_collected(points):
	fruit_count += points
	update_display()
	print("Collected fruit! Total: ", fruit_count)

func update_display():
	$FruitLabel.text = "Fruits: " + str(fruit_count)