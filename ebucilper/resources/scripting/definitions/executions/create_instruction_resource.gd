class_name CreateInstructionResource extends ExecutionInstructionResource

@export var name := VariableExpressionResource.new()
@export var value: int

func _init() -> void:
	type = InstructionType.CREATE_VAR
