extends Node

@onready var exeInstructionScene : PackedScene = load("res://scenes/UI/commands/instruction_exe.tscn")
@onready var flowInstructionScene : PackedScene = load("res://scenes/UI/commands/instruction_flow.tscn")

signal variableCreationInstantiated(variable: VariableExpressionResource)

func instantiate(instruction: LogicResource) -> Control:
	var instance = Control.new()
	if(instruction is ExecutionLogicResource):
		instance = exeInstructionScene.instantiate()
		#if(instruction is CreateLogicResource):
			#emit_signal("variableCreationInstantiated", instruction.name)
	elif(instruction is ListLogicResource):
		instance = flowInstructionScene.instantiate()
	else:
		printerr("Can't build instruction UI")
		return instance
	
	instance.instructionResource = instruction
	
	return instance
