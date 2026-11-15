@tool
extends Node2D

enum StartSide { LEFT, RIGHT }

@export var offset = Vector2(320, 0):
	set(value):
		offset = value
		queue_redraw()
@export var duration: float = 10.0
@export var wait_time: float = 1.5
@export var start_side: StartSide = StartSide.LEFT:
	set(value):
		start_side = value
		queue_redraw()

func _ready():
	if Engine.is_editor_hint():
		return
	var start = _start_pos()
	var end = Vector2.ZERO if start_side == StartSide.RIGHT else offset
	$TileMapLayer.position = start

	var tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops()
	tween.tween_property($TileMapLayer, "position", end, duration / 2.0)
	tween.tween_interval(wait_time)
	tween.tween_property($TileMapLayer, "position", start, duration / 2.0)
	tween.tween_interval(wait_time)

func _start_pos() -> Vector2:
	return offset if start_side == StartSide.RIGHT else Vector2.ZERO

func _draw():
	if not Engine.is_editor_hint():
		return
	draw_line(Vector2.ZERO, offset, Color.YELLOW, 2.0)
	draw_circle(Vector2.ZERO, 4.0, Color.YELLOW)
	draw_circle(offset, 4.0, Color.YELLOW)
	draw_circle(_start_pos(), 7.0, Color.GREEN)   # 출발점
