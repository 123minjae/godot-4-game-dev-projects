extends Node

@export var coin_scene : PackedScene
@export var playTime = 30

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

func _ready() -> void:
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playTime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	
func spawn_coins():
	for i in level+4:
		var c = coin_scene.instantiate()
		add_child(c, true)
		c.screensize = screensize
		c.position = Vector2(randi_range(0,screensize.x),randi_range(0,screensize.y))
