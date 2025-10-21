extends Node3D

@export var cell_size: float = 1.0
@export var grid_size: int = 10
@export var small_axe_color: Color = Color.WHITE
@export var line_color: Color = Color.BLACK


var cellOffset = Vector3(-0.5,-0.5,-0.5)

var mesh_instance: MeshInstance3D

func _ready():
	var immediate_mesh = ImmediateMesh.new()
	mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = immediate_mesh
	add_child(mesh_instance)

	draw_grid(immediate_mesh)



func create_axis(start: Vector3, end: Vector3, radius: float, color: Color):
	var axis = MeshInstance3D.new()
	var cyl = CylinderMesh.new()
	cyl.height = start.distance_to(end)
	cyl.top_radius = radius
	cyl.bottom_radius = radius
	cyl.radial_segments = 12
	axis.mesh = cyl
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	axis.material_override = mat

	var dir = (end - start).normalized()
	var mid = (start + end) * 0.5

	var _basis = Basis()
	_basis.y = dir
	if abs(dir.dot(Vector3.UP)) > 0.999:
		_basis.x = dir.cross(Vector3.FORWARD).normalized()
	else:
		_basis.x = dir.cross(Vector3.UP).normalized()
	_basis.z = _basis.x.cross(dir).normalized()

	axis.transform = Transform3D(_basis, mid)

	add_child(axis)
	
	
func create_cone_head(_position: Vector3, direction: Vector3, radius: float, height: float, color: Color):
	var cone_instance = MeshInstance3D.new()
	var cone = CylinderMesh.new()
	cone.top_radius = 0.0 
	cone.bottom_radius = radius
	cone.height = height
	cone.radial_segments = 12
	cone_instance.mesh = cone

	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	cone_instance.material_override = mat

	var dir = direction.normalized()
	var _basis = Basis()
	_basis.y = dir
	if abs(dir.dot(Vector3.UP)) > 0.999:
		_basis.x = dir.cross(Vector3.FORWARD).normalized()
	else:
		_basis.x = dir.cross(Vector3.UP).normalized()
	_basis.z = _basis.x.cross(dir).normalized()

	var offset_pos = _position + dir * (height * 0.5)
	cone_instance.transform = Transform3D(_basis, offset_pos)

	add_child(cone_instance)
	

func draw_grid(immediate_mesh: ImmediateMesh):
	
	var size = grid_size * cell_size
	var start = Vector3(0, 0, 0) + cellOffset
	# Axes Z
	var end_z = Vector3(0, 0, size + 1.0) + cellOffset
	create_axis(start, end_z, 0.05, line_color)
	create_cone_head(end_z, end_z - start, 0.15, 0.4, line_color)
	## Axe X
	var end_x = Vector3(size + 1.0, 0, 0) + cellOffset
	create_axis(start, end_x, 0.05, line_color)
	create_cone_head(end_x, end_x - start, 0.15, 0.4, line_color)
	## Axe Y
	var end_y = Vector3(0,size + 1.0,  0) + cellOffset
	create_axis(start , end_y, 0.05, line_color)
	create_cone_head(end_y, end_y - start , 0.15, 0.4, line_color)
	
	
	var axis_shader: Shader = Shader.new()
	axis_shader.code = """
		shader_type spatial;
		render_mode unshaded, cull_disabled, fog_disabled;

		uniform vec4 tint : source_color = vec4(1.0);
		uniform vec3  grid_center = vec3(5.0);
		uniform float max_dist    = 5.0;
		uniform float alpha_min   = 0.0;
		uniform float alpha_max   = 0.5;

		varying float v_alpha;
		
		void vertex() {
			float d = distance(VERTEX, grid_center);
			float t = 1.0 - clamp(d / max_dist, 0.0, 1.0);
			v_alpha = mix(alpha_min, alpha_max, t);
		}
		
		void fragment() {
		    ALBEDO = tint.rgb;
		    ALPHA = alpha_max-v_alpha;
		}
	"""
	var axis_mat: ShaderMaterial = ShaderMaterial.new()
	axis_mat.shader = axis_shader
	axis_mat.set_shader_parameter("tint", small_axe_color)

	var axis_len: float = cell_size * 0.1
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, axis_mat)

	for ix in range(grid_size + 1):
		for iy in range(grid_size + 1):
			for iz in range(grid_size + 1):
				var p: Vector3 = Vector3(ix, iy, iz) * cell_size + cellOffset

				if ix == 0:
					immediate_mesh.surface_add_vertex(p)
					immediate_mesh.surface_add_vertex(p + Vector3(axis_len, 0, 0))
				elif ix == grid_size:
					immediate_mesh.surface_add_vertex(p)
					immediate_mesh.surface_add_vertex(p + Vector3(-axis_len, 0, 0))
				else:
					immediate_mesh.surface_add_vertex(p)
					immediate_mesh.surface_add_vertex(p + Vector3(axis_len, 0, 0))
					immediate_mesh.surface_add_vertex(p)
					immediate_mesh.surface_add_vertex(p + Vector3(-axis_len, 0, 0))

				if iy == 0:
					immediate_mesh.surface_add_vertex(p)
					immediate_mesh.surface_add_vertex(p + Vector3(0, axis_len, 0))
				elif iy == grid_size:
					immediate_mesh.surface_add_vertex(p)
					immediate_mesh.surface_add_vertex(p + Vector3(0, -axis_len, 0))
				else:
					immediate_mesh.surface_add_vertex(p)
					immediate_mesh.surface_add_vertex(p + Vector3(0, axis_len, 0))
					immediate_mesh.surface_add_vertex(p)
					immediate_mesh.surface_add_vertex(p + Vector3(0, -axis_len, 0))

				if iz == 0:
					immediate_mesh.surface_add_vertex(p)
					immediate_mesh.surface_add_vertex(p + Vector3(0, 0, axis_len))
				elif iz == grid_size:
					immediate_mesh.surface_add_vertex(p)
					immediate_mesh.surface_add_vertex(p + Vector3(0, 0, -axis_len))
				else:
					immediate_mesh.surface_add_vertex(p)
					immediate_mesh.surface_add_vertex(p + Vector3(0, 0, axis_len))
					immediate_mesh.surface_add_vertex(p)
					immediate_mesh.surface_add_vertex(p + Vector3(0, 0, -axis_len))

	immediate_mesh.surface_end()
