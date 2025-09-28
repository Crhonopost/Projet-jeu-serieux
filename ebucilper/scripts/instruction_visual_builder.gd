extends Node

@onready var exeInstructionScene : PackedScene = load("res://scenes/UI/commands/instruction_exe.tscn")

func instantiate(instruction: InstructionResource) -> Node2D:
	if(instruction is ExecutionInstructionResource):
		var instance = exeInstructionScene.instantiate()
		instance.instructionResource = instruction
		return instance
	else:
		return Node2D.new()
