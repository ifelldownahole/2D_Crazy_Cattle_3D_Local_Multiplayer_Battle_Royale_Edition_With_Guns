extends RigidBody2D
@export var poison_gas_scene: PackedScene

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(50)
	name = "Toilet"
	await get_tree().create_timer(0.5).timeout
	explode()
	
func _on_body_entered(_filler):
	explode()
	
func explode():
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	var poison_gas = poison_gas_scene.instantiate()
	poison_gas.position = Vector2(0,-14).rotated(poison_gas.rotation)
	add_child(poison_gas)
	set_deferred("collision_layer",0)
	set_deferred("collision_mask",0)
	$Sprite2D.hide()
	await get_tree().create_timer(5).timeout
	queue_free()
