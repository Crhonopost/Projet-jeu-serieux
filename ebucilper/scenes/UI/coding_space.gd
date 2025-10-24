extends Control

@onready var variableItemScene : PackedScene = load("res://scenes/UI/commands/editor/variable_item.tscn")

@onready var compiler := $Compiler 
@onready var functionsNode := $CodeContainer/Functions


var selectedFunction: int = 0
@export var functions : Array[FunctionLogicResource]

signal launch

func _ready() -> void:
	for fct in functions:
		var fctUI := InstructionVisualBuilder.instantiate(fct)
		fctUI.visible = false
		functionsNode.add_child(fctUI)
	
	functionsNode.get_child(0).visible = true

func _on_button_pressed() -> void:
	emit_signal("launch")

func retrieveInstructions() -> Array[Instruction]:
	return compiler.processAllInstructions(functions)


func _on_function_select_value_changed(value: float) -> void:
	functionsNode.get_child(selectedFunction).visible = false
	functionsNode.get_child(int(value)).visible = true
	selectedFunction = value
