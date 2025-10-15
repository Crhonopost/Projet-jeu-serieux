class_name UpdateLogicResource extends ExecutionLogicResource

@export var name := VariableExpressionResource.new()
@export var expression: ExpressionResource = VariableExpressionResource.new()

func _init() -> void:
	type = InstructionType.UPDATE_VAR
