extends Camera2D

@export var player_path: NodePath
@export var screen_height = 540

var player
var current_section = 0  # Track which vertical section we're in

func _ready():
	player = get_node(player_path)
	if not player:
		push_error("Player node not found! Set the player_path in the inspector.")
	
	# Set anchor mode to top-left
	anchor_mode = ANCHOR_MODE_FIXED_TOP_LEFT

func _process(_delta):
	if not player:
		return
		
	var player_pos = player.global_position
	var camera_top = global_position.y
	var camera_bottom = global_position.y + screen_height
	# Check if player moves beyond top of current section
	if player_pos.y < camera_top:
		# Move camera up one section
		print("Moving up")
		print(camera_top, " ", player_pos.y)
		global_position.y -= screen_height
		current_section += 1
		
	# Check if player moves beyond bottom of current section
	elif player_pos.y > camera_bottom:
		print("Moving down")
		print(camera_bottom, " ", player_pos.y)
		# Move camera down one section
		global_position.y += screen_height
		current_section -= 1
