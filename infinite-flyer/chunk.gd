extends Node3D

var buildings = [
	preload("res://buildings/building_1.tscn"),
	preload("res://buildings/building_2.tscn"),
	preload("res://buildings/building_3.tscn"),
	preload("res://buildings/building_4.tscn"),
	preload("res://buildings/building_5.tscn"),
]
var ring = preload("res://ring.tscn")
var obstacles = [
	preload("res://buildings/obstacle_1.tscn"),  # 컨테이너 벽: 위로 넘기
	preload("res://buildings/obstacle_2.tscn"),  # 육교: 아래로 지나가기
	preload("res://buildings/obstacle_3.tscn"),  # 전봇대: 좌우로 피하기
]

var level = 0

func _ready() -> void:
	add_buildings()
	add_center_obstacles()
	add_rings()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
	
func add_buildings():
	for side in [-1,1]:
		var zpos = -10
		for i in 18:
			if randf() > 0.75:
				zpos -= randi_range(5,10)
				continue
			var nb = buildings[randi_range(0,buildings.size()-1)].instantiate()
			add_child(nb)
			nb.transform.origin.z = zpos
			nb.transform.origin.x = 20 * side
			zpos -= nb.get_node("MeshInstance3D").mesh.get_aabb().size.z
			
func add_center_obstacles():
	if level>0:
		for z in range(-10, -200, -40):
			if randf() > 0.6:
				var idx = randi_range(0, obstacles.size() - 1)
				var ob = obstacles[idx].instantiate()
				add_child(ob)
				ob.position.z = z
				if idx == 2:
					ob.position.x = randi_range(-10,10)
				
				

func add_rings():
	for z in range(0,-200,-20):
		if randf() > 0.70:
			var nr = ring.instantiate()
			nr.position.z = z
			nr.position.y = randf_range(5,17)
			match level:
				0:pass
				1:
					nr.move_y = true
				2:
					nr.position.x = randf_range(-10,10)
					nr.move_y = true
				3:
					nr.position.x = randf_range(-10,10)
					nr.move_x = true
				_:
					nr.position.x = randf_range(-10,10)
					if randf_range(0,1) < 0.5:
						nr.move_x = true
					else:
						nr.move_y = true
			add_child(nr)
