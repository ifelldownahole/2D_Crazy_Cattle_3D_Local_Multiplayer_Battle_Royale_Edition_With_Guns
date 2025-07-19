extends RigidBody2D
var speed = 0
var direction = 0
var ANGULAR_SPEED = PI
@export var TURN_SPEED_MULTIPLIER = 0.005
var velocity = Vector2.ZERO
@export var MAX_SPEED = 300
@export var ACCELERATION = 50
@export var DECELERATION = 25

func _process(delta):
	
	direction = 0
	if Input.is_action_pressed("ui_a"):
		direction -= TURN_SPEED_MULTIPLIER * sqrt(speed * speed)
	if Input.is_action_pressed("ui_d"):
		direction += TURN_SPEED_MULTIPLIER * sqrt(speed * speed)
	rotation += ANGULAR_SPEED * direction * delta

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
	position += velocity * delta
	print(speed)

func _on_button_pressed():
	position = Vector2(300,300)
