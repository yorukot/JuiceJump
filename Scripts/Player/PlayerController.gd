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
@export var max_charge_time = 1.5

var target_velocity = Vector2.ZERO
var jump_direction = Vector2.ZERO
var is_charging = false
var current_charge = 0


func _physics_process(delta):
	var direction = Vector2.ZERO
	
	# Handle jump charging
	if is_on_floor():
		# Start charging jump when pressing jump button
		if Input.is_action_just_pressed("jump"):
			is_charging = true
			current_charge = 0
			jump_direction = Vector2(0, -1) # Default to up

		# While charging, accumulate charge and set direction
		if is_charging:
			# Update the charging animation (crouch)
			
			# Accumulate charge
			current_charge += charge_rate * delta
			current_charge = min(current_charge, max_jump_force)
			
			# Set jump direction based on input
			if Input.is_action_pressed("move_right"):
				jump_direction = Vector2(1, -1).normalized()
			elif Input.is_action_pressed("move_left"):
				jump_direction = Vector2(-1, -1).normalized()
			else:
				jump_direction = Vector2(0, -1) # Default to up
				
			# When jump button is released, apply the jump
			if Input.is_action_just_released("jump"):
				is_charging = false
				# Apply jump velocity
				target_velocity = jump_direction * current_charge
				
	else:
		# Allow movement in air
		is_charging = false
	
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y + (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
