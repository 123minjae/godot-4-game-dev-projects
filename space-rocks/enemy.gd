extends Area2D

@export var bullet_scene:PackedScene
@export var speed = 150
@export var rotation_speed = 120
@export var health = 3

var follow = PathFollow2D.new()
var target = null

func _ready() -> void:
	$Sprite2D.frame = randi()%3
	var path = $EnemyPaths.get_children()[randi() % $EnemyPaths.get_child_count()]
	path.add_child(follow)
	follow.loop = false
	
func _physics_process(delta: float) -> void:
	rotation += deg_to_rad(rotation_speed) * delta
	follow.progress += speed * delta
	position = follow.global_position
	if follow.progress_ratio >= 1:
		queue_free()

func _on_gun_cooldown_timeout() -> void:
	pass # Replace with function body.
