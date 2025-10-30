extends Node3D
class_name SelectionBox3D

@export var cell_size: float = 1.0
@export var color: Color = Color(0.0, 0.0, 0.0, 1.0)

var mi: MeshInstance3D

func _ready() -> void:
	var imm := ImmediateMesh.new()
	mi = MeshInstance3D.new()
	mi.mesh = imm
	add_child(mi)

	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = color
	mat.transparent = true
	mi.material_override = mat

	_draw_wire_cube(imm)

func _draw_wire_cube(imm: ImmediateMesh) -> void:
	var s := cell_size
	var p0 := Vector3(0, 0, 0)
	var p1 := Vector3(s, 0, 0)
	var p2 := Vector3(s, s, 0)
	var p3 := Vector3(0, s, 0)
	var p4 := Vector3(0, 0, s)
	var p5 := Vector3(s, 0, s)
	var p6 := Vector3(s, s, s)
	var p7 := Vector3(0, s, s)

	# 12 条边（LINES）
	imm.clear_surfaces()
	imm.surface_begin(Mesh.PRIMITIVE_LINES)

	# 底面
	imm.surface_add_vertex(p0); imm.surface_add_vertex(p1)
	imm.surface_add_vertex(p1); imm.surface_add_vertex(p2)
	imm.surface_add_vertex(p2); imm.surface_add_vertex(p3)
	imm.surface_add_vertex(p3); imm.surface_add_vertex(p0)

	# 顶面
	imm.surface_add_vertex(p4); imm.surface_add_vertex(p5)
	imm.surface_add_vertex(p5); imm.surface_add_vertex(p6)
	imm.surface_add_vertex(p6); imm.surface_add_vertex(p7)
	imm.surface_add_vertex(p7); imm.surface_add_vertex(p4)

	# 立柱
	imm.surface_add_vertex(p0); imm.surface_add_vertex(p4)
	imm.surface_add_vertex(p1); imm.surface_add_vertex(p5)
	imm.surface_add_vertex(p2); imm.surface_add_vertex(p6)
	imm.surface_add_vertex(p3); imm.surface_add_vertex(p7)

	imm.surface_end()
