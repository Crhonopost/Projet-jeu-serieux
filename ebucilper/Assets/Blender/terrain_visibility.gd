extends Node3D

@onready var camera = get_node("../CameraTarget/OrbitCamera")

func _process(delta):
	if camera.position.y < -5.0:
		visible = false
	else:
		visible = true
