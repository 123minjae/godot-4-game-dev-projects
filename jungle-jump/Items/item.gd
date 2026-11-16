extends Area2D

signal picked_up(type)

var textures = {
	"cherry": "res://assets/sprites/cherry.png",
	"gem": "res://assets/sprites/gem.png"
}
var item_type = ""

func init(type,_position):
	item_type = type
	$Sprite2D.texture = load(textures[type])
	position = _position

func _on_body_entered(body: Node2D) -> void:
	picked_up.emit(item_type)
	queue_free()
