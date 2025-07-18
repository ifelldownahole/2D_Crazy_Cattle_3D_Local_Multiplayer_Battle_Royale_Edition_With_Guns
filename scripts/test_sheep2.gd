extends RigidBody2D

var speed = 0
var velocity = Vector2.ZERO
var ANGULAR_SPEED = PI
@export var MAX_HEALTH = 500
var health = MAX_HEALTH
@export var TURN_SPEED_MULTIPLIER = 1200
@export var ACCELERATION = 10000

@export var FORWARD = "ui_w"
@export var REVERSE = "ui_s"
@export var TURN_LEFT = "ui_a"
@export var TURN_RIGHT = "ui_d"

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(50)
	$healthBar.max_value = health

func _process(delta):
	speed = linear_velocity.length()
	$healthBar.value = health
	if Input.is_action_pressed(TURN_LEFT):
		apply_torque(-TURN_SPEED_MULTIPLIER * sqrt(speed * speed) * delta)
	if Input.is_action_pressed(TURN_RIGHT):
		apply_torque(TURN_SPEED_MULTIPLIER * sqrt(speed * speed) * delta)
		
	if Input.is_action_pressed(FORWARD):	
		apply_force(Vector2.UP.rotated(rotation) * ACCELERATION * delta)
		
	if Input.is_action_pressed(REVERSE):	
		apply_force(Vector2.UP.rotated(rotation) * -ACCELERATION * delta)
		
func _on_body_entered(_TestSheep):
	health -= linear_velocity.length()
	if health < 0:
		health = 0
	hit_physics(linear_velocity.length())
	
func hit_physics(force):
	var delay = force / 100
	angular_velocity += angular_velocity
	linear_damp = 0
	angular_damp = 0
	await get_tree().create_timer(delay).timeout
	linear_damp = 0.5
	angular_damp = 2.5
	await get_tree().create_timer(delay).timeout
	linear_damp = 1
	angular_damp = 5

#func _on_timer_timeout():
	#print(constant_force)
