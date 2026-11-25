extends Control

func _ready() -> void:
	$HighScore.text = "High Score : "+str(Global.high_score)
	$TextureButton.grab_focus()

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
