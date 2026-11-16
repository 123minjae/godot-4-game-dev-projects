extends CharacterBody2D

@export var speed = 50
@export var gravity = 900

var facing = 1

func _ready():
	set_facing(facing)

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x = facing * speed
	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Player":
			collision.get_collider().hurt()
		if is_on_wall():
			set_facing(int(sign(get_wall_normal().x)))
			velocity.y = -100

	if is_on_floor() and not $RayCast2D.is_colliding():
		set_facing(-facing)

	if position.y > 10000:
		queue_free()

func set_facing(dir: int):
	facing = dir
	$Sprite2D.flip_h = facing > 0
	$RayCast2D.position.x = abs($RayCast2D.position.x) * facing

func take_damage():
	$HitSound.play()
	$AnimationPlayer.play("death")
	$CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		queue_free()
