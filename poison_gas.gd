extends Area2D
var spawn_location = Vector2.ZERO

func _ready():
	name = "PoisonGas"
	$Sprite2D.show()
	$GPUParticles2D.show()
	spawn_location = global_position
	
func _process(_delta):
	#global_position = spawn_location
	pass
