extends RigidBody2D
var speed = 0
var direction = 0
var ANGULAR_SPEED = PI
@export var TURN_SPEED_MULTIPLIER = 0.15
@export var TURNING_DECELERATION_MULTIPLIER = 2
var velocity = Vector2.ZERO
@export var MAX_SPEED = 300
@export var ACCELERATION = 50
@export var DECELERATION = 25

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(1)

func _process(delta):
	
	direction = 0
	if Input.is_action_pressed("ui_a"):
		direction -= TURN_SPEED_MULTIPLIER * sqrt(speed * speed)
	if Input.is_action_pressed("ui_d"):
		direction += TURN_SPEED_MULTIPLIER * sqrt(speed * speed)
	angular_velocity = ANGULAR_SPEED * direction * delta

	if Input.is_action_pressed("ui_w"):	
		speed += ACCELERATION * delta
		
	if Input.is_action_pressed("ui_s"):	
		speed -= ACCELERATION * delta
	# speed ajustments for momentum
	if speed > 0:
		if speed >= DECELERATION * delta:
			speed -= DECELERATION * delta
		else:
			speed = 0
	if speed < 0:
		if speed <= -DECELERATION * delta:
			speed += DECELERATION * delta
		else:
			speed = 0
	if speed > MAX_SPEED:
		speed = MAX_SPEED
	if speed < -MAX_SPEED:
		speed = -MAX_SPEED
	velocity = Vector2.UP.rotated(rotation) * speed
	constant_force = velocity
	linear_velocity = constant_force
	print(linear_velocity)

func _on_body_entered():
	speed = constant_force.length()
	velocity = Vector2.UP.rotated(rotation) * speed
	constant_force = velocity
	linear_velocity = constant_force
