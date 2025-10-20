extends Node3D

@export var cell_size: float = 1.0
@export var grid_size: int = 10
@export var line_color: Color = Color.WHITE

var cellOffset = Vector3(-0.5,-0.5,-0.5)

var mesh_instance: MeshInstance3D

func _ready():
	var immediate_mesh = ImmediateMesh.new()
	mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = immediate_mesh
	add_child(mesh_instance)

	draw_grid(immediate_mesh)


func draw_grid(immediate_mesh: ImmediateMesh):
	immediate_mesh.clear_surfaces()
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)

	var size = grid_size * cell_size

	# Tracer les lignes parallèles aux axes
	#for i in range(grid_size + 1):
		#var offset = i * cell_size
#
		## X parallèle
		#for j in range(grid_size + 1):
			#var offset2 = j * cell_size
			## lignes sur Z
			#immediate_mesh.surface_add_vertex(Vector3(0, offset, offset2) + cellOffset)
			#immediate_mesh.surface_add_vertex(Vector3(size, offset, offset2) + cellOffset)
			## lignes sur Y
			#immediate_mesh.surface_add_vertex(Vector3(offset2, 0, offset) + cellOffset)
			#immediate_mesh.surface_add_vertex(Vector3(offset2, size, offset) + cellOffset)
#
		## Z parallèle
		#for j in range(grid_size + 1):
			#var offset2 = j * cell_size
			#immediate_mesh.surface_add_vertex(Vector3(offset, offset2, 0) + cellOffset)
			#immediate_mesh.surface_add_vertex(Vector3(offset, offset2, size) + cellOffset)
	
	# Axes Z
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 0) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, size) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(size, 0, 0) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(size, 0, size) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(0, size, 0) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(0, size, size) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(size, size, 0) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(size, size, size) + cellOffset)
	# Axe X
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 0) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(size, 0, 0) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, size) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(size, 0, size) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(0, size, 0) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(size, size, 0) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(0, size, size) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(size, size, size) + cellOffset)
	# Axe Y
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 0) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(0, size, 0) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(size, 0, 0) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(size, size, 0) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, size) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(0, size, size) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(size, 0, size) + cellOffset)
	immediate_mesh.surface_add_vertex(Vector3(size, size, size) + cellOffset)
	
	immediate_mesh.surface_end()
