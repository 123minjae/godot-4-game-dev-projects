extends RigidBody2D

signal lives_changed
signal dead

var reset_pos = false
var lives = 0:set = set_lives

var screensize

enum {INIT,ALIVE,INVULNERABLE,DEAD}
var state = INIT

@export var engine_power = 500
@export var spin_power = 8000

var thrust = Vector2.ZERO
var rotation_dir = 0

@export var bullet_scene : PackedScene
@export var fire_rate = 0.25
var radius = 0

var can_shoot = true

signal shield_changed

@export var max_shield = 100.0
@export var shield_regen = 5.0

var shield = 0: set = set_shield

func _ready() -> void:
	change_state(INIT)
	screensize = get_viewport_rect().size
	$GunCooldown.wait_time = fire_rate
	radius = $CollisionShape2D.shape.get_rect().size.x / 2

func change_state(new_state):
	match new_state:
		INIT:
			$CollisionShape2D.set_deferred("disabled",true)
			$Sprite2D.modulate.a = 0.5
		ALIVE:
			$CollisionShape2D.set_deferred("disabled",false)
			$Sprite2D.modulate.a = 1
		INVULNERABLE:
			$CollisionShape2D.set_deferred("disabled",true)
			$Sprite2D.modulate.a = 0.5
			$InvulnerabilityTimer.start()
		DEAD:
			$CollisionShape2D.set_deferred("disabled",true)
			$Sprite2D.hide()
			linear_velocity = Vector2.ZERO
			$EngineSound.stop()
			dead.emit()
	state = new_state
	
func _process(delta: float) -> void:
	shield += shield_regen * delta
	get_input()
	
func get_input():
	thrust = Vector2.ZERO
	if state in [DEAD, INIT]:
		return
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * engine_power
		if not $EngineSound.playing:
			$EngineSound.play()
	else:
		$EngineSound.stop()
	rotation_dir = Input.get_axis("rotate_left","rotate_right")
	
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
		
func shoot():
	if state == INVULNERABLE:
		return
	$LaserSound.play()
	can_shoot = false
	$GunCooldown.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start($Muzzle.global_transform)
	
func _physics_process(delta: float) -> void:
	constant_force = thrust
	constant_torque = rotation_dir * spin_power
	
func _integrate_forces(physics_state):
	var xform = physics_state.transform
	xform.origin.x = wrapf(xform.origin.x, -radius, screensize.x + radius)
	xform.origin.y = wrapf(xform.origin.y, -radius, screensize.y + radius)
	physics_state.transform = xform
	
	if reset_pos:
		physics_state.transform.origin = screensize/2
		reset_pos = false


func _on_gun_cooldown_timeout() -> void:
	can_shoot = true
	
func set_lives(value):
	lives = value
	shield = max_shield
	lives_changed.emit(lives)
	if lives <= 0:
		change_state(DEAD)
	else:
		change_state(INVULNERABLE)

func reset():
	reset_pos = true
	$Sprite2D.show()
	lives = 3
	change_state(ALIVE)


func _on_invulnerability_timer_timeout() -> void:
	change_state(ALIVE)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("rocks"):
		shield -= body.size * 25
		body.explode()
		

func explode():
	$Explosion.show()
	$Explosion/AnimationPlayer.play("explosion")
	await  $Explosion/AnimationPlayer.animation_finished
	$Explosion.hide()
	
func set_shield(value):
	value = min(value,max_shield)
	shield = value
	shield_changed.emit(shield/max_shield)
	if shield <= 0 :
		lives -= 1
		explode()
