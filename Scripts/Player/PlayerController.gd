extends CharacterBody2D

# How fast the player moves in pixels per second.
@export var speed = 100
# The downward acceleration when in the air, in pixels per second squared.
@export var fall_acceleration = 1000
# Maximum jump force
@export var max_jump_force = 1000
# How quickly jump charges (force gained per second)
@export var charge_rate = 300
# Maximum charge time in seconds
@export var max_charge_time = 3.0
# Minimum jump angle (radians) - 0 degrees (horizontal)
@export var min_jump_angle = 0.0
# Maximum jump angle (radians) - 75 degrees (mostly vertical)
@export var max_jump_angle = deg_to_rad(75.0)
# Bounce energy retention factor (how much energy is kept when bouncing)
@export var bounce_factor = 0.7

var target_velocity = Vector2.ZERO
var jump_direction = 0 # 0 for none, 1 for right, -1 for left
var is_charging = false
var current_charge = 0
var charge_time = 0.0
var fruits_collected = 0
var current_animation_index = 0

# Flag to prevent multiple jump triggers
var jump_button_pressed = false

# Reference to the juicer audio controller
@onready var juicer_audio = $JuicerAudio

# Signal emitted when fruit is collected
signal fruit_collected(points)

func _ready():
	# Add the player to the "Player" group for fruit detection
	add_to_group("Player")
	
	# Connect to audio signals
	juicer_audio.start_finished.connect(_on_juicer_start_finished)
	juicer_audio.end_finished.connect(_on_juicer_end_finished)
	
	# Set default animation
	$AnimatedSprite2D.play("juice_normal")
	update_animation_frame()

func _physics_process(delta):
	# Track the jump button state
	var just_pressed_jump = Input.is_action_just_pressed("jump")
	var just_released_jump = Input.is_action_just_released("jump")
	
	# Handle jump charging and jumping
	if is_on_floor():
		# Start charging jump when pressing space button
		if just_pressed_jump and not is_charging and not jump_button_pressed:
			is_charging = true
			jump_button_pressed = true
			current_charge = 0
			charge_time = 0.0
			
			# Play the juicer start sound
			juicer_audio.play_start()
		
		# Reset jump button state when released
		if just_released_jump:
			jump_button_pressed = false
			
		# While charging, accumulate charge
		if is_charging:
			# Accumulate charge time and force
			charge_time += delta
			charge_time = min(charge_time, max_charge_time)
			current_charge = (charge_time / max_charge_time) * max_jump_force
			
			# When jump is released, apply the jump
			if just_released_jump:
				
				# Set jump direction based on input
				if Input.is_action_pressed("move_right"):
					jump_direction = 1
				elif Input.is_action_pressed("move_left"):
					jump_direction = -1
				else:
					jump_direction = 0
					
				# Calculate jump angle based on charge time
				var charge_percent = charge_time / max_charge_time
				var jump_angle = lerp(min_jump_angle, max_jump_angle, charge_percent)
				
				# Calculate jump direction vector from angle
				var jump_dir = Vector2(cos(jump_angle), -sin(jump_angle))
				jump_dir.x *= jump_direction # Apply left/right direction
				
				# Apply jump velocity
				target_velocity = jump_dir * current_charge
				
				# Reset charging state
				is_charging = false
				
				# Play the juicer end sound
				juicer_audio.play_end()

	# Check for wall collisions and bounce
	if is_on_wall() or is_on_ceiling():
		# Simply reverse the velocity components based on the collision
		if is_on_wall():
			target_velocity.x *= -0.5 * bounce_factor
		if is_on_ceiling():
			target_velocity.y *= -0.5 * bounce_factor

	# Vertical Velocity - Apply gravity
	if not is_on_floor():
		target_velocity.y += fall_acceleration * delta
	
	if is_on_floor():
		target_velocity.x = lerp(target_velocity.x, 0.0, 0.1)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()

func _process(_delta):
	# Make sure sounds are stopped when not charging or jumping
	if not is_charging and is_on_floor() and abs(target_velocity.length()) < 10:
		juicer_audio.stop_all()
	
	# Check if animation frame needs to be updated
	update_animation_frame()

# Audio signal handlers
func _on_juicer_start_finished():
	pass

func _on_juicer_end_finished():
	pass
	
# Called when a fruit is collected
func collect_fruit(points):
	fruits_collected += points
	emit_signal("fruit_collected", points)
	# Update animation frame when fruits are collected
	update_animation_frame()
	
# Getter for the total fruits collected
func get_fruits_collected():
	return fruits_collected

# Updates the animation frame based on number of fruits collected
func update_animation_frame():
	var frame_index = 0
	
	if fruits_collected >= 10:
		frame_index = 5
	elif fruits_collected >= 8:
		frame_index = 4
	elif fruits_collected >= 6:
		frame_index = 3
	elif fruits_collected >= 4:
		frame_index = 2
	elif fruits_collected >= 2:
		frame_index = 1
	else:
		frame_index = 0
	
	# Only update if the frame has changed
	if frame_index != current_animation_index:
		current_animation_index = frame_index
		$AnimatedSprite2D.frame = current_animation_index
