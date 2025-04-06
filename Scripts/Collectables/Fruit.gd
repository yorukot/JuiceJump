extends Area2D

@export var points := 1  # Points awarded for collecting this fruit
@export var bounce_effect := true  # Whether the fruit should animate when idle

signal fruit_collected(points)

func _ready():
	# Connect the body_entered signal to our _on_body_entered function
	body_entered.connect(_on_body_entered)
	
	# Set up a simple animation if bounce_effect is enabled
	if bounce_effect:
		var tween = create_tween()
		tween.set_loops()  # Make the animation loop indefinitely
		tween.tween_property($Sprite2D, "scale", Vector2(1.1, 1.1), 0.5)
		tween.tween_property($Sprite2D, "scale", Vector2(1.0, 1.0), 0.5)

func _on_body_entered(body):
	# Check if the body that entered is the player
	if body.is_in_group("Player"):
		collect(body)

func collect(player = null):
	# Emit the collected signal with the points value
	emit_signal("fruit_collected", points)
	
	# If player is provided, directly call its collect_fruit method
	if player and player.has_method("collect_fruit"):
		player.collect_fruit(points)
	
	# Play collection animation/sound (optional)
	if has_node("AudioStreamPlayer2D"):
		$AudioStreamPlayer2D.play()
	
	# Disable collision to prevent multiple collects
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Create a visual effect for collection
	var collection_tween = create_tween()
	collection_tween.tween_property($Sprite2D, "scale", Vector2(1.5, 1.5), 0.15)
	collection_tween.tween_property($Sprite2D, "scale", Vector2(0, 0), 0.15)
	collection_tween.tween_callback(queue_free)  # Remove the fruit after animation