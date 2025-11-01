extends Control

@onready var variableItemScene : PackedScene = load("res://scenes/UI/commands/editor/variable_item.tscn")

@onready var compiler := $Compiler 
@onready var functionsNode := $HBoxContainer/LeftSide/Functions


var selectedFunction: int = 0
@export var functions : Array[FunctionLogicResource]

@onready var functionEditionScene : PackedScene = load("res://scenes/UI/commands/functions/function_edition.tscn")

signal launch

func _ready() -> void:
	for i in range(functions.size()):
		add_function(functions[i])
		
	InstructionVisualBuilder.connect("functionCallInstantiatiated", functionCall)
	
func setAuthorizedInstuctions(instructions: AuthorizedInstructions):
	$HBoxContainer/VBoxContainer/PanelContainer/MarginContainer/Inventory.allow_instructions(instructions)

func setTip(tip: String):
	$HBoxContainer/LeftSide/PanelContainer/MarginContainer/Goal.text = tip

func functionCall(node: Control):
	node.getSpecialNode().connect("connectToFunction", func (index): connectNodeToFunction(index, node))
	node.getSpecialNode().linkWithFunctionRes(functions[functionsNode.current_tab])

func connectNodeToFunction(index: int, node: Node):
	node.getSpecialNode().linkWithFunctionRes(functions[index])

func _on_button_pressed() -> void:
	emit_signal("launch")

func retrieveInstructions() -> Array[Instruction]:
	return compiler.processAllInstructions(functions)


func _on_functions_tab_selected(tab: int) -> void:
	selectedFunction = tab

func add_function(function: FunctionLogicResource):
	var fctUI := functionEditionScene.instantiate()
	fctUI.edit_function(function)
	functionsNode.add_child(fctUI)
	functionsNode.set_tab_title(functionsNode.get_child_count()-1, function.name)
	
	function.connect("updateFuncName", func (name): functionsNode.set_tab_title(functionsNode.get_child_count()-1, name))

func _on_add_function_pressed() -> void:
	functions.append(FunctionLogicResource.new())
	add_function(functions.back())
