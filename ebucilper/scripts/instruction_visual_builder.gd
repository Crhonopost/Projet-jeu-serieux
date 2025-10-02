extends Node

@onready var exeInstructionScene : PackedScene = load("res://scenes/UI/commands/instruction_exe.tscn")
@onready var forInstructionScene : PackedScene = load("res://scenes/UI/commands/instruction_flow.tscn")

signal variableCreationInstantiated(variable: VariableResource)

func instantiate(instruction: InstructionResource) -> Control:
	var instance = Control.new()
	if(instruction is ExecutionInstructionResource):
		instance = exeInstructionScene.instantiate()
		if(instruction is CreateInstructionResource):
			emit_signal("variableCreationInstantiated", instruction.name)
	elif(instruction is ForInstructionResource):
		instance = forInstructionScene.instantiate()
	else:
		printerr("Can't build instruction UI")
		return instance
	
	instance.instructionResource = instruction
	
	return instance
