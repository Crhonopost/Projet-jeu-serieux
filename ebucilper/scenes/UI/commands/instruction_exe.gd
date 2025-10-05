extends Control

@export var instructionResource: ExecutionInstructionResource

@onready var typeLabel: Label = $HBoxContainer/Type

signal exitCode

@onready var variableCreationScene : PackedScene = load("res://scenes/UI/commands/executions/variable_creation.tscn")
@onready var colorPickingScene : PackedScene = load("res://scenes/UI/commands/executions/color_picking.tscn")
@onready var variableUpdateScene : PackedScene = load("res://scenes/UI/commands/executions/variable_update.tscn")


func _ready():
	buildFromResource()

func retrieveCommand() -> Array[Instruction.InstructionType]:
	return []

func _on_delete_pressed() -> void:
	emit_signal("exitCode")

func buildFromResource():
	if(!instructionResource): return
	
	typeLabel.text = instructionResource.getName()
	
	if instructionResource is CreateInstructionResource:
		var argsInstance = variableCreationScene.instantiate()
		argsInstance.creation = instructionResource
		$HBoxContainer/Special.add_child(argsInstance)
	elif instructionResource.type == Instruction.InstructionType.CHANGE_COLOR:
		var argsInstance = colorPickingScene.instantiate()
		argsInstance.color = instructionResource
		$HBoxContainer/Special.add_child(argsInstance)
	elif instructionResource.type == Instruction.InstructionType.UPDATE_VAR:
		var argsInstance = variableUpdateScene.instantiate()
		argsInstance.update = instructionResource
		$HBoxContainer/Special.add_child(argsInstance)


func _get_drag_data(at_position: Vector2) -> Variant:
	var title: Label = Label.new()
	title.text = instructionResource.getName()
	set_drag_preview(title)
	emit_signal("exitCode")
	return instructionResource
