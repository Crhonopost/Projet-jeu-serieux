extends Node3D

const ColorsEnum = Global.ColorsEnum

@export var cellInstance: PackedScene

@export var colors: Array[Color] = [Color("pink"), Color("red"), Color("blue")]

func instantiate(position: Vector3, colorIdx: int , isTransparent := false):
	var bloc: MeshInstance3D = cellInstance.instantiate()
	bloc.position = position
	var mat = StandardMaterial3D.new()
	mat.albedo_color = colors[colorIdx]
	if isTransparent:
		var alpha = 0.2
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		var col: Color = mat.albedo_color
		col.a = alpha
		mat.albedo_color = col
	bloc.material_override = mat;
	add_child(bloc)

func clear():
	for child in get_children():
		child.queue_free()
