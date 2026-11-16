extends CanvasLayer

@export var duration = 1.0
@onready var rect = $ColorRect

var busy = false

func change_scene(path: String):
	if busy:
		return
	busy = true
	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, duration)
	await tween.finished
	get_tree().change_scene_to_file(path)
	tween = create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, duration)
	await tween.finished
	busy = false
