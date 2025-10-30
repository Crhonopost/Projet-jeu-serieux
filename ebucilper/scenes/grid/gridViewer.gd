extends Node


@export var drone_scene: PackedScene
@export var currentGrid : GridResource
enum showTargetBlockMode {all,layer,smaller}
@export var mode : showTargetBlockMode : set = set_mode
var playerGrid: GridResource = GridResource.new() 
@onready var builder: Node3D = $"../Builder"
@export var cell_size: float = 1.0 
@export var move_time_per_cell := 0.10

var _last_layer := -1
var drone: Node3D
var anim : AnimationPlayer

var move_tween: Tween

# func _ready() -> void:
	# fillgrid(gridTarget,0.05)
	# fillgrid(gridEditor,0.05)
	# placeBlocs(gridTarget,true)
	# placeBlocs(gridEditor, false)
func _ready():
	builder.grid = playerGrid
	if drone_scene:
		drone = drone_scene.instantiate()
		add_child(drone)
		_set_drone_immediately(builder.cursorPosition, builder.cursorOrientation)
		_setup_drone_anim(2)
		if builder and not builder.cursor_moved.is_connected(_on_cursor_moved):
			builder.cursor_moved.connect(_on_cursor_moved)

	
func _process(_dt):
	if mode == showTargetBlockMode.layer and currentGrid != null and builder != null:
		var S := currentGrid.gridScale
		var k := clampi(builder.cursorPosition.y, 0, S - 1)
		if k != _last_layer:
			if $Visualization.has_method("clear_target"):
				$Visualization.clear_target()
			_draw_target_layer(k)
			_last_layer = k

func _on_cursor_moved(pos: Vector3i, orientation: int) -> void:
	if drone == null: return
	
	if move_tween and move_tween.is_running():
		move_tween.kill()

	var from := drone.position
	var to := Vector3(pos.x, pos.y, pos.z) * cell_size
	to.y += cell_size * 1.0

	var dis: float = (absf(from.x - to.x) + absf(from.y - to.y) + absf(from.z - to.z)) / cell_size
	var dur: float = maxf(1.0, dis) * move_time_per_cell

	var yaw := 0.0
	match orientation:
		builder.OrientationsEnum.X_POSITIVE: yaw = deg_to_rad(90)
		builder.OrientationsEnum.X_NEGATIVE: yaw = deg_to_rad(-90)
		builder.OrientationsEnum.Z_POSITIVE: yaw = 0.0
		builder.OrientationsEnum.Z_NEGATIVE: yaw = deg_to_rad(180)

	move_tween = get_tree().create_tween()
	move_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	move_tween.tween_property(drone, "position", to, dur)
	move_tween.parallel().tween_property(drone, "rotation:y", yaw, dur)


func _set_drone_immediately(pos: Vector3i, orientation: int) -> void:
	var p := Vector3(pos.x, pos.y, pos.z) * cell_size
	p.y += cell_size * 0.5
	drone.position = p
	var yaw := 0.0
	match orientation:
		builder.OrientationsEnum.X_POSITIVE: yaw = 0.0
		builder.OrientationsEnum.X_NEGATIVE: yaw = deg_to_rad(180)
		builder.OrientationsEnum.Z_POSITIVE: yaw = deg_to_rad(90)
		builder.OrientationsEnum.Z_NEGATIVE: yaw = deg_to_rad(-90)
	drone.rotation = Vector3(0, yaw, 0)

func set_mode(v:int) -> void:
	if mode == v:
		return
	mode = v
	if $Visualization.has_method("clear_target"):
		$Visualization.clear_target()
	match mode:
		showTargetBlockMode.all:
			showTargetBlock(showTargetBlockMode.all, true, builder.cursorPosition)
		showTargetBlockMode.layer:
			_last_layer = -1

func _setup_drone_anim(speedScale:float) -> void:
	anim = drone.find_child("AnimationPlayer", true, false)
	if anim:
		var list := anim.get_animation_list()
		print("Drone animations: ", list)

		var name_anim := "Start_Liftoff"
		if not anim.has_animation(name_anim) and list.size() > 0:
			name_anim = list[0]

		var a: Animation = anim.get_animation(name_anim)
		if a:
			a.loop_mode = Animation.LOOP_PINGPONG

		anim.speed_scale = speedScale
		anim.play(name_anim)
		return



func clearGrid():
	currentGrid.clear()
	$Visualization.clear()
	
func clear_player():
	$Visualization.clear()


func placePlayerBlocs() -> void:
	var S := playerGrid.gridScale
	for i in range(S):
		for k in range(S):
			for j in range(S):
				var idx := i + k * S + j * S * S
				var c := playerGrid.grid[idx]
				if c != Global.ColorsEnum.NONE:
					$Visualization.instantiate(Vector3(i, k, j), c, false)


func placeBlocs(gridResource : GridResource, isTransparent : bool) :
	for i in range (gridResource.gridScale) :
		for j in range (gridResource.gridScale) :
			for k in range (gridResource.gridScale) :
				var current = gridResource.grid[i + k * gridResource.gridScale + j * gridResource.gridScale * gridResource.gridScale]
				if(current != Global.ColorsEnum.NONE):
					$Visualization.instantiate(Vector3(i,k,j),current,isTransparent);


func fillgrid(gridResource : GridResource, prob : float):
	for i in range (gridResource.grid.size()):
		gridResource.grid[i] = Global.ColorsEnum.RED

		
		
func _draw_target_layer(k:int) -> void:
	var S := currentGrid.gridScale
	for i in range(S):
		for j in range(S):
			var idx := i + k * S + j * S * S
			var c := currentGrid.grid[idx]
			if c != 0:
				$Visualization.instantiate(Vector3(i, k, j), c, true)
				

		
func showTargetBlock(showMode : showTargetBlockMode , show : bool, cursor_position:Vector3i):

	if not show or currentGrid == null:
		push_warning("showTargetBlock: currentGrid is null or show is false")
		return
	#$Visualization.clear()
	
	var S := currentGrid.gridScale

	if showMode == showTargetBlockMode.all:
		for i in range(S):
			for k in range(S):
				for j in range(S):
					var idx := i + k * S + j * S * S
					var c := currentGrid.grid[idx]
					if c != 0:
						$Visualization.instantiate(Vector3(i, k, j), c, true)

	elif showMode == showTargetBlockMode.layer:
		_draw_target_layer(clampi(cursor_position.y, 0, S - 1))
