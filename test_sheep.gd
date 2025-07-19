extends RigidBody2D
signal hit
signal dead
var speed = 0
var ammo1 = 0
var ammo2 = 0
var defence_multiplier = 1
var damage_multiplier = 1
var spinout_multiplier = 1
var weapon1 = "weapon_name"
var weapon2 = "weapon_name"
var reloaded1 = true
var reloaded2 = true
var paused = true
var healing = false
var poisoned = false
@export var bullet_scene: PackedScene
@export var toilet_scene: PackedScene
var velocity = Vector2.ZERO
@export var MAX_HEALTH = 1000
var health = MAX_HEALTH
@export var TURN_SPEED_MULTIPLIER = 1200
@export var ACCELERATION = float(12000)
@export var FORWARD = "ui_w"
@export var REVERSE = "ui_s"
@export var TURN_LEFT = "ui_a"
@export var TURN_RIGHT = "ui_d"
@export var SHOOT1 = "ui_q"
@export var SHOOT2 = "ui_e"
@export var SPAWN_POS = Vector2(125,500)
@export var SPAWN_DIRECTION = float(0)

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(50)
	$AmmoBar1.hide()
	$AmmoNumber1.hide()
	$ReloadBar1.hide()
	$AmmoBar2.hide()
	$AmmoNumber2.hide()
	$ReloadBar2.hide()
	$NukeExplosion.hide()
	$healthBar.max_value = MAX_HEALTH
	$healthBar.value = health
	position = SPAWN_POS
	rotation = SPAWN_DIRECTION * PI

func _process(delta):
	speed = linear_velocity.length()
	if poisoned:
		damaged(50 * delta,0)
	if paused:
		return
	
	if Input.is_action_pressed(TURN_LEFT):
		apply_torque(-TURN_SPEED_MULTIPLIER * sqrt(speed * speed) * delta)
	if Input.is_action_pressed(TURN_RIGHT):
		apply_torque(TURN_SPEED_MULTIPLIER * sqrt(speed * speed) * delta)
		
	if Input.is_action_pressed(FORWARD):
		apply_force(Vector2.UP.rotated(rotation) * ACCELERATION * delta)
		
	if Input.is_action_pressed(REVERSE):
		apply_force(Vector2.UP.rotated(rotation) * -ACCELERATION * delta)
	
	if Input.is_action_just_pressed(SHOOT1):
		if ammo1 > 0 and reloaded1:
			if weapon1 == "gun":
				activate_gun(1)
			if weapon1 == "boost":
				activate_boost(1)
			if weapon1 == "heal":
				activate_heal(1)
			if weapon1 == "toilet":
				activate_toilet(1)
				
	if Input.is_action_just_pressed(SHOOT2):
		if ammo2 > 0 and reloaded2:
			if weapon2 == "gun":
				activate_gun(2)
			if weapon2 == "boost":
				activate_boost(2)
			if weapon2 == "heal":
				activate_heal(2)
			if weapon2 == "toilet":
				activate_toilet(2)
	
func _on_body_entered(source):
	if speed == linear_velocity.length():
		print(name + " Oh no instant")
	source = str(source)
	if source.contains("Bullet"):
		damaged(100,1)
		hit_physics(100)
	if source.contains("Wall"):
		if speed == linear_velocity.length():
			print(name + " Oh no wall")
		damaged(speed/4,0)
	if source.contains("TestSheep"):
		hit.emit(source,speed * damage_multiplier,spinout_multiplier)
	if source.contains("Toilet"):
		linear_velocity = linear_velocity / 2

func hit_physics(force):
	var delay = clampf(force / 100,0,5)
	linear_damp = 0.5
	angular_damp = 2.5
	await get_tree().create_timer(delay).timeout
	linear_damp = 1
	angular_damp = 5

func activate_gun(weapon_used):
	if weapon_used == 1:
		ammo1 -= 1
		$AmmoBar1.value = ammo1
		$AmmoNumber1.set_text(str(ammo1))
		var bullet = bullet_scene.instantiate()
		bullet.position = Vector2(0,-50).rotated(bullet.rotation)
		bullet.linear_velocity = Vector2.UP.rotated(rotation) * 300
		add_child(bullet)
		if ammo1 <= 0:
			$AmmoBar1.hide()
			$AmmoNumber1.hide()
			weapon1 = "weapon_name"
		reloaded1 = false
		$ReloadBar1.show()
		$ReloadBar1.max_value = 5
		for i in range(6):
			$ReloadBar1.value = i
			$ReloadTimer1.start(0.5/6)
			await $ReloadTimer1.timeout
		$ReloadBar1.hide()
		reloaded1 = true
		
	if weapon_used == 2:
		ammo2 -= 1
		$AmmoBar2.value = ammo2
		$AmmoNumber2.set_text(str(ammo2))
		var bullet = bullet_scene.instantiate()
		bullet.position = Vector2(0,-50).rotated(bullet.rotation)
		bullet.linear_velocity = Vector2.UP.rotated(rotation) * 300
		add_child(bullet)
		if ammo2 <= 0:
			$AmmoBar2.hide()
			$AmmoNumber2.hide()
			weapon2 = "weapon_name"
		reloaded2 = false
		$ReloadBar2.show()
		$ReloadBar2.max_value = 5
		for i in range(6):
			$ReloadBar2.value = i
			$ReloadTimer2.start(0.5/6)
			await $ReloadTimer2.timeout
		$ReloadBar2.hide()
		reloaded2 = true
	
func activate_boost(weapon_used):
	if weapon_used == 1:
		ammo1 -= 1
		$AmmoBar1.hide()
		$AmmoNumber1.hide()
		weapon1 = "weapon_name"
		paused = true
		linear_damp = 0
		angular_damp = 10
		defence_multiplier = 0
		spinout_multiplier = 0.5
		apply_force(Vector2.UP.rotated(rotation) * ACCELERATION * 2)
		reloaded1 = false
		$ReloadBar1.show()
		$ReloadBar1.max_value = 5
		for i in range(6):
			$ReloadBar1.value = i
			$ReloadTimer1.start(0.5/6)
			await $ReloadTimer1.timeout
		$ReloadBar1.hide()
		reloaded1 = true
		linear_damp = 1
		angular_damp = 5
		defence_multiplier = 1
		spinout_multiplier = 1
		paused = false
		
	if weapon_used == 2:
		ammo2 -= 1
		$AmmoBar2.hide()
		$AmmoNumber2.hide()
		weapon2 = "weapon_name"
		paused = true
		linear_damp = 0
		angular_damp = 10
		defence_multiplier = 0
		spinout_multiplier = 0.5
		apply_force(Vector2.UP.rotated(rotation) * ACCELERATION * 2)
		reloaded2 = false
		$ReloadBar2.show()
		$ReloadBar2.max_value = 5
		for i in range(6):
			$ReloadBar2.value = i
			$ReloadTimer2.start(0.5/6)
			await $ReloadTimer2.timeout
		$ReloadBar2.hide()
		reloaded2 = true
		linear_damp = 1
		angular_damp = 5
		defence_multiplier = 1
		spinout_multiplier = 1
		paused = false
	
func activate_heal(weapon_used):
	if weapon_used == 1:
		ammo1 -= 1
		$AmmoBar1.hide()
		$AmmoNumber1.hide()
		weapon1 = "weapon_name"
		healing = true
		$HealingParticles.emitting = true
		for i in range(20):
			if healing == false:
				$HealingParticles.emitting = false
				return
			health += 25
			$healthBar.value = health
			if health > MAX_HEALTH:
				health = MAX_HEALTH
				$HealingParticles.emitting = false
				return
			await get_tree().create_timer(0.5).timeout
		$HealingParticles.emitting = false
		
	if weapon_used == 2:
		ammo2 -= 1
		$AmmoBar2.hide()
		$AmmoNumber2.hide()
		weapon2 = "weapon_name"
		healing = true
		$HealingParticles.emitting = true
		for i in range(20):
			if healing == false:
				$HealingParticles.emitting = false
				return
			health += 25
			$healthBar.value = health
			if health > MAX_HEALTH:
				health = MAX_HEALTH
				$HealingParticles.emitting = false
				return
			await get_tree().create_timer(0.5).timeout
		$HealingParticles.emitting = false

func activate_nuke():
	hit.emit("ALL",69420,1)
	$NukeExplosion.show()
	for i in range(100):
		$NukeExplosion.scale += Vector2(1,1)
		await get_tree().create_timer(0.01).timeout
	$NukeExplosion.hide()
	
func activate_toilet(weapon_used):
	if weapon_used == 1:
		ammo1 -= 1
		$AmmoBar1.hide()
		$AmmoNumber1.hide()
		weapon1 = "weapon_name"
		var toilet = toilet_scene.instantiate()
		toilet.position = Vector2(0,-50).rotated(toilet.rotation)
		toilet.linear_velocity = Vector2.UP.rotated(rotation) * 600
		add_child(toilet)
		
	if weapon_used == 2:
		ammo2 -= 1
		$AmmoBar2.hide()
		$AmmoNumber2.hide()
		weapon2 = "weapon_name"
		var toilet = toilet_scene.instantiate()
		toilet.position = Vector2(0,-50).rotated(toilet.rotation)
		toilet.linear_velocity = Vector2.UP.rotated(rotation) * 600
		add_child(toilet)
	
func damaged(damage,force_multiplier):
	if damage * defence_multiplier > 0:
		healing = false
		if force_multiplier > 0:
			hit_physics(damage * force_multiplier)
		health -= damage * defence_multiplier
		print(damage)
		if health < 0:
			health = 0
			dead.emit(name)
			paused = true
		$healthBar.value = health

func _on_hit(target,damage,force_multiplier):
	if target.contains(name) or target.contains("ALL"):
		damaged(damage,force_multiplier)

func _on_main_reset():
	health = MAX_HEALTH
	ammo1 = 0
	ammo2 = 0
	$AmmoBar1.hide()
	$AmmoNumber1.hide()
	$AmmoBar2.hide()
	$AmmoNumber2.hide()
	$healthBar.value = health
	await get_tree().create_timer(0.01).timeout
	position = SPAWN_POS
	rotation = SPAWN_DIRECTION * PI
	await get_tree().create_timer(0.01).timeout
	set_physics_process(true)
	paused = false


func _on_main_game_over():
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	set_physics_process(false)
	paused = true


func _on_loot_box_collected(player):
	if player.contains(name):
		var weapon_gained = randi_range(1,100)
		if weapon_gained == 100:
			activate_nuke()
			return
		weapon_gained = randi_range(0,3)
		if weapon1.contains("weapon_name") == false and weapon2.contains("weapon_name") == false:
			return
		if weapon_gained == 0:
			if weapon1.contains("weapon_name") and weapon2.contains("gun") == false:
				ammo1 = 3
				$AmmoBar1.max_value = ammo1
				$AmmoBar1.value = ammo1
				$AmmoBar1.show()
				$AmmoNumber1.show()
				$AmmoNumber1.set_text(str(ammo1))
				$AmmoBar1.get("theme_override_styles/fill").bg_color = Color("d26e30")
				$ReloadBar1.get("theme_override_styles/fill").bg_color = Color("d26e30")
				weapon1 = "gun"
			elif weapon2.contains("weapon_name") and weapon1.contains("gun") == false:
				ammo2 = 3
				$AmmoBar2.max_value = ammo2
				$AmmoBar2.value = ammo2
				$AmmoBar2.show()
				$AmmoNumber2.show()
				$AmmoNumber2.set_text(str(ammo2))
				$AmmoBar2.get("theme_override_styles/fill").bg_color = Color("d26e30")
				$ReloadBar2.get("theme_override_styles/fill").bg_color = Color("d26e30")
				weapon2 = "gun"
			else:
				_on_loot_box_collected(name)
				return
				
		if weapon_gained == 1:
			if weapon1.contains("weapon_name") and weapon2.contains("boost") == false:
				ammo1 = 1
				$AmmoBar1.max_value = ammo1
				$AmmoBar1.value = ammo1
				$AmmoBar1.show()
				$AmmoNumber1.show()
				$AmmoNumber1.set_text(str(ammo1))
				weapon1 = "boost"
				$AmmoBar1.get("theme_override_styles/fill").bg_color = Color("d26eff")
				$ReloadBar1.get("theme_override_styles/fill").bg_color = Color("d26eff")
			elif weapon2.contains("weapon_name") and weapon1.contains("boost") == false:
				ammo2 = 1
				$AmmoBar2.max_value = ammo2
				$AmmoBar2.value = ammo2
				$AmmoBar2.show()
				$AmmoNumber2.show()
				$AmmoNumber2.set_text(str(ammo2))
				weapon2 = "boost"
				$AmmoBar2.get("theme_override_styles/fill").bg_color = Color("d26eff")
				$ReloadBar2.get("theme_override_styles/fill").bg_color = Color("d26eff")
			else:
				_on_loot_box_collected(name)
				return

		if weapon_gained == 2:
			if weapon1.contains("weapon_name") and weapon2.contains("heal") == false:
				ammo1 = 1
				$AmmoBar1.max_value = ammo1
				$AmmoBar1.value = ammo1
				$AmmoBar1.show()
				$AmmoNumber1.show()
				$AmmoNumber1.set_text(str(ammo1))
				$AmmoBar1.get("theme_override_styles/fill").bg_color = Color("00cf00")
				weapon1 = "heal"
			elif weapon2.contains("weapon_name") and weapon1.contains("heal") == false:
				ammo2 = 1
				$AmmoBar2.max_value = ammo2
				$AmmoBar2.value = ammo2
				$AmmoBar2.show()
				$AmmoNumber2.show()
				$AmmoNumber2.set_text(str(ammo2))
				$AmmoBar2.get("theme_override_styles/fill").bg_color = Color("00cf00")
				weapon2 = "heal"
			else:
				_on_loot_box_collected(name)
				return

		if weapon_gained == 3:
			if weapon1.contains("weapon_name") and weapon2.contains("toilet") == false:
				ammo1 = 1
				$AmmoBar1.max_value = ammo1
				$AmmoBar1.value = ammo1
				$AmmoBar1.show()
				$AmmoNumber1.show()
				$AmmoNumber1.set_text(str(ammo1))
				$AmmoBar1.get("theme_override_styles/fill").bg_color = Color("66300d")
				$ReloadBar1.get("theme_override_styles/fill").bg_color = Color("66300d")
				weapon1 = "toilet"
			elif weapon2.contains("weapon_name") and weapon1.contains("toilet") == false:
				ammo2 = 1
				$AmmoBar2.max_value = ammo2
				$AmmoBar2.value = ammo2
				$AmmoBar2.show()
				$AmmoNumber2.show()
				$AmmoNumber2.set_text(str(ammo2))
				$AmmoBar2.get("theme_override_styles/fill").bg_color = Color("66300d")
				$ReloadBar2.get("theme_override_styles/fill").bg_color = Color("66300d")
				weapon2 = "toilet"
			else:
				_on_loot_box_collected(name)
				return

func _on_area_entered(source):
	source = str(source)
	if source.contains("PoisonGas"):
		poisoned = true
		ACCELERATION = ACCELERATION / 2

func _on_area_exited(source):
	source = str(source)
	if source.contains("PoisonGas"):
		poisoned = false
		ACCELERATION = ACCELERATION * 2
