extends Node3D

const ColorsEnum = Global.ColorsEnum

@export var cellInstance: PackedScene

@export var colors: Array[Color] = [Color("pink"), Color("red"), Color("blue")]

func instantiate(position: Vector3, colorIdx: int , isTransparent := false):
	var bloc: MeshInstance3D = cellInstance.instantiate()
	bloc.position = position
	var mat = StandardMaterial3D.new()
	mat.albedo_color = colors[colorIdx]
	bloc.material_override = mat;
	add_child(bloc)
