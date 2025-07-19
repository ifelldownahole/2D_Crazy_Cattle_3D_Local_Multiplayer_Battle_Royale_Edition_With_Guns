extends Area2D
signal collected

func _ready():
	set_monitoring(true)
	name = "LootBox"
	$Sprite2D.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$SpawningBar.hide()

func _on_body_entered(source):
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.hide()
	spawn_new_box()
	source = str(source)
	collected.emit(source)

func _on_main_reset():
	$SpawningBar.hide()
	$Sprite2D.show()
	$CollisionShape2D.set_deferred("disabled", false)
	position = Vector2(575,300)

func spawn_new_box():
	position = Vector2(randf_range(100,1000),randf_range(100,500))
	$SpawningBar.show()
	$SpawningBar.max_value = 5
	for i in range(6):
		$SpawningBar.value = i
		$SpawningTimer.start(float(1) / 6)
		await $SpawningTimer.timeout
	$SpawningBar.hide()
	$Sprite2D.show()
	$CollisionShape2D.set_deferred("disabled", false)
