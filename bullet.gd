extends RigidBody2D

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(50)
	name = "Bullet"

func _on_body_entered(_filler):
	queue_free()
