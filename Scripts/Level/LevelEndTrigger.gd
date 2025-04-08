extends Area2D

func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)
	
	# Create a colored rectangle for visibility
	var sprite = $Sprite2D
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 1, 0, 0.5))  # Green semi-transparent color
	var texture = ImageTexture.create_from_image(image)
	sprite.texture = texture

func _on_body_entered(body):
	# Check if the body that entered is the player
	if body.is_in_group("Player"):
		# Load the EndGameScreen scene directly
		get_tree().change_scene_to_file("res://Scripts/UI/EndGameScreen.gd")