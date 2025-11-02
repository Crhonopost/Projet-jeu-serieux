extends Node3D

signal block_placed(position: Vector3i, color: Global.ColorsEnum)
signal finish_instructions()

var cell_size: float = 1
var actions: Array[Dictionary]
var move_tween: Tween
@export var move_time_per_cell := 0.10

@onready var selector: SelectionBox3D = $SelectionBox3D
@onready var cursor_robot: Node3D = $Sketchfab_Scene

func _ready() -> void:
	var anim = $Sketchfab_Scene/AnimationPlayer
	anim.play_section("Start_Liftoff", 17)

	selector.cell_size = cell_size


func move_to(position: Vector3i, orientation: Global.OrientationsEnum):
	if($TransitionTimer.is_stopped()):
		$TransitionTimer.start()
	actions.append({"move_position": position, "move_orientation": orientation})

func place_block(position: Vector3i, color: Global.ColorsEnum):
	if($TransitionTimer.is_stopped()):
		$TransitionTimer.start()
	actions.append({"place_color": color, "place_position": position})



func _on_transition_timer_timeout() -> void:
	if(actions.size() > 0):
		var action = actions.pop_front()
		if(action.has("move_position")):
			m_move_cursor(action["move_position"], action["move_orientation"])
		elif(action.has("place_color")):
			block_placed.emit(action["place_position"], action["place_color"])
	else:
		finish_instructions.emit()
		$TransitionTimer.stop()

func get_orientation_y(orientation: Global.OrientationsEnum) -> float:
	var yaw := 0.0
	match orientation:
		Global.OrientationsEnum.X_POSITIVE: yaw = deg_to_rad(90)
		Global.OrientationsEnum.X_NEGATIVE: yaw = deg_to_rad(-90)
		Global.OrientationsEnum.Z_POSITIVE: yaw = 0.0
		Global.OrientationsEnum.Z_NEGATIVE: yaw = deg_to_rad(180)
	
	return yaw

func _set_drone_immediately(pos: Vector3i, orientation: int, cell_length: float) -> void:
	cell_size = cell_length
	var p := Vector3(pos) * cell_size
	selector.position = p - Vector3(cell_size,cell_size,cell_size)
	cursor_robot.position = p + Vector3.UP * 1.5
	var yaw := get_orientation_y(orientation)
	cursor_robot.rotation = Vector3(0, yaw, 0)

func m_move_cursor(pos: Vector3i, orientation: int) -> void:
	if move_tween and move_tween.is_running():
		move_tween.kill()

	var placement_position := Vector3(pos) * cell_size * 2
	
	var from := cursor_robot.position
	var to := placement_position + Vector3.UP * 1.5

	var dis: float = (absf(from.x - to.x) + absf(from.y - to.y) + absf(from.z - to.z)) / cell_size
	var dir: float = maxf(1.0, dis) * move_time_per_cell

	var yaw := get_orientation_y(orientation)

	move_tween = get_tree().create_tween()
	move_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	move_tween.tween_property(cursor_robot, "position", to, dir)
	move_tween.parallel().tween_property(cursor_robot, "rotation:y", yaw, dir)
	
	selector.position = placement_position - Vector3(0.5,0.5,0.5)
