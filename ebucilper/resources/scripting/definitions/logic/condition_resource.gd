class_name ConditionResource extends Resource


@export var variableA: ExpressionResource
@export var comparator: LowLevelExpression.OperatorEnum
@export var variableB: ExpressionResource

func getComparatorText():
	LowLevelExpression.operatorToStr(comparator)
