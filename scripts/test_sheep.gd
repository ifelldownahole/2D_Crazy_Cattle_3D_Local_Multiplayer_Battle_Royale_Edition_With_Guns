extends RigidBody2D
var speed = 0
var velocity = Vector2.ZERO
var ANGULAR_SPEED = PI
var thread = null # Assign the thread object to this variable
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
	thread = Thread.new() # Create a new thread object
	print("iexistiguess")

# test function for the thread

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
	thread.start(hit_physics.bind(linear_velocity.length())) # Start the thread
	
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
	print(OS.get_thread_caller_id())
	print(OS.get_main_thread_id())

# Thread must be disposed (or "joined"), for portability.
func _exit_tree():
	thread.wait_to_finish()
#func _on_timer_timeout():
	#print(constant_force)
