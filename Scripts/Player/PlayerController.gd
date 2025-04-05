extends CharacterBody2D

# How fast the player moves in pixels per second.
@export var speed = 100
# The downward acceleration when in the air, in pixels per second squared.
@export var fall_acceleration = 1000
# Maximum jump force
@export var max_jump_force = 500
# How quickly jump charges (force gained per second)
@export var charge_rate = 300
# Maximum charge time in seconds
@export var max_charge_time = 1.0
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

func _physics_process(delta):
	# Handle jump charging and jumping
	if is_on_floor():
		# Start charging jump when pressing space button
		if Input.is_action_just_pressed("jump"):
			is_charging = true
			current_charge = 0
			charge_time = 0.0
			
		# While charging, accumulate charge
		if is_charging:
			# Accumulate charge time and force
			charge_time += delta
			charge_time = min(charge_time, max_charge_time)
			current_charge = (charge_time / max_charge_time) * max_jump_force
			
			# When direction is pressed after charging, apply the jump
			if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
				# Set jump direction based on input
				if Input.is_action_pressed("move_right"):
					jump_direction = 1
				elif Input.is_action_pressed("move_left"):
					jump_direction = -1
					
				# Calculate jump angle based on charge time
				var charge_percent = charge_time / max_charge_time
				var jump_angle = lerp(min_jump_angle, max_jump_angle, charge_percent)
				
				# Calculate jump direction vector from angle
				var jump_dir = Vector2(cos(jump_angle), -sin(jump_angle))
				jump_dir.x *= jump_direction  # Apply left/right direction
				
				# Apply jump velocity
				target_velocity = jump_dir * current_charge
				
				# Reset charging state
				is_charging = false
				
				# Update sprite direction
				if jump_direction < 0:
					$Sprite2D.flip_h = true
				elif jump_direction > 0:
					$Sprite2D.flip_h = false
		
		# Cancel charging if jump is released before direction is pressed
		if Input.is_action_just_released("jump") and is_charging:
			is_charging = false
			current_charge = 0
			charge_time = 0.0

	# Check for wall collisions and bounce
	if is_on_wall() or is_on_ceiling():
		# Simply reverse the velocity components based on the collision
		if is_on_wall():
			target_velocity.x *= -0.5 * bounce_factor
		if is_on_ceiling():
			target_velocity.y *= -0.5 * bounce_factor

		# Update the sprite direction based on bounce
		if target_velocity.x < 0:
			$Sprite2D.flip_h = true
		elif target_velocity.x > 0:
			$Sprite2D.flip_h = false

	# Vertical Velocity - Apply gravity
	if not is_on_floor():
		target_velocity.y += fall_acceleration * delta
	
	if is_on_floor():
		target_velocity.x = lerp(target_velocity.x, 0.0, 0.1)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()

func _process(_delta):
	# Visual feedback for charging
	if is_charging:
		var charge_percent = charge_time / max_charge_time
		_update_charging_visual(charge_percent)
	else:
		_reset_charging_visual()

# Update visuals based on charge amount
func _update_charging_visual(charge_percent):
	# Scale the sprite down a bit to indicate crouching
	var scale_y = 1.0 - (charge_percent * 0.3)
	$Sprite2D.scale.y = scale_y
	
	# You can add more visual effects here:
	# - Particle effects
	# - Color modulation
	# - Animation changes

# Reset visuals when not charging
func _reset_charging_visual():
	$Sprite2D.scale = Vector2(1.0, 1.0)
