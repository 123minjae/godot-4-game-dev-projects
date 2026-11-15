extends Control

@onready var message = $Message

func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property(message, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(message, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		GameState.next_level()
