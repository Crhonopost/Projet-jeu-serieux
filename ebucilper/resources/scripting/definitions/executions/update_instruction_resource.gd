class_name UpdateInstructionResource extends ExecutionInstructionResource

@export var name := VariableExpressionResource.new()
@export var expression: ExpressionResource = VariableExpressionResource.new()

func _init() -> void:
	type = InstructionType.UPDATE_VAR
