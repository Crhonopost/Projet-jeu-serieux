extends Node3D

@export var cell_size: float = 1.0
@export var grid_size: int = 10
@export var small_axe_color: Color = Color.WHITE
@export var line_color: Color = Color.BLACK
@export var num_color: Color = Color.LINEN
@export var axeletter_color: Color = Color.RED




var cellOffset = Vector3(-0.5,-0.5,-0.5)

var mesh_instance: MeshInstance3D

func _ready():
	var immediate_mesh = ImmediateMesh.new()
	mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = immediate_mesh
	add_child(mesh_instance)

	draw_grid(immediate_mesh)
	axis_labels()

func _make_label3d(txt: String, color: Color,pixel_size :float = 0.0011) -> Label3D:
	var L := Label3D.new()
	L.text = txt
	L.modulate = color
	L.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	L.fixed_size = true
	L.double_sided = true
	L.pixel_size = pixel_size
	L.outline_size = 1
	return L
	
func axis_labels():
	var size: float = float(grid_size) * cell_size
	var start: Vector3 = Vector3(0, 0, 0)
	var off_y := Vector3(0, 0.25 * cell_size, 0)
	var off_x := Vector3(0.25 * cell_size, 0, 0)
	var off_z := Vector3(0, 0.25 * cell_size, 0)

	# axe x
	var p_X := start + Vector3(size, 0, 0) - Vector3(-1.5,0.5,0.5)
	var lbl_X := _make_label3d('X', axeletter_color,0.0015)
	lbl_X.position = p_X + off_y
	add_child(lbl_X)
	for i in range(0, grid_size):
		var p := start + Vector3(i*cell_size, 0, 0) - Vector3(0,1,1)
		var lbl := _make_label3d(str(i), num_color)
		lbl.position = p + off_y
		add_child(lbl)
	# axe y
	var p_Y := start + Vector3(0,size, 0) - Vector3(0.5,-1.5,0.5)
	var lbl_Y := _make_label3d('Y', axeletter_color,0.0015)
	lbl_Y.position = p_Y + off_x
	add_child(lbl_Y)
	for i in range(0, grid_size):
		var p := start + Vector3(0, i * cell_size, 0) - Vector3(1,0,1)
		var lbl := _make_label3d(str(i), num_color)
		lbl.position = p + off_x
		add_child(lbl)

	#axe z
	var p_Z := start + Vector3(0,0, size) - Vector3(0.5,0.5,-1.5)
	var lbl_Z := _make_label3d('Z', axeletter_color,0.0015)
	lbl_Z.position = p_Z + off_y
	add_child(lbl_Z)
	for i in range(0, grid_size ):
		var p := start + Vector3(0, 0, i * cell_size) - Vector3(1,1,0)
		var lbl := _make_label3d(str(i), num_color)
		lbl.position = p + off_y
		add_child(lbl)

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
		uniform vec3  grid_center = vec3(4.5);
		uniform float max_dist    = 5.0;
		uniform float alpha_min   = 0.0;
		uniform float alpha_max   = 0.5;

		varying float v_alpha;
		
		void vertex() {
			float d = distance(VERTEX, grid_center);
			float radius = max_dist * 0.9;
			float fade   = max_dist * 0.4;

			float a = smoothstep(radius, radius + fade, d);

			v_alpha = mix(alpha_min, alpha_max, a);
		}
		
		void fragment() {
		    ALBEDO = tint.rgb;
		    ALPHA = v_alpha;
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
