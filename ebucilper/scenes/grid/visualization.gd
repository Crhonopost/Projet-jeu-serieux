extends Node3D

@export var cellInstance: PackedScene

func instantiate(position: Vector3, color: Color):
	var bloc: Node3D = cellInstance.instantiate()
	bloc.position = position
	add_child(bloc)
