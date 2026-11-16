extends Node

var num_levels = 2
var current_level = 0

var game_scene = "res://main.tscn"
var title_screen = "res://UI/title.tscn"

func next_level():
	if ScreenFade.busy:
		return
	current_level += 1
	if current_level <= num_levels:
		ScreenFade.change_scene(game_scene)
	else:
		restart()

func restart():
	current_level = 0
	ScreenFade.change_scene(title_screen)
