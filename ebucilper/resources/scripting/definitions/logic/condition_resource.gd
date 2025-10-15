class_name ConditionResource extends Resource

var COMPARATORS_NAMES = {
	Instruction.Comparators.SUPERIOR: ">",
	Instruction.Comparators.INFERIOR: "<",
	Instruction.Comparators.EQUAL: "=="
}

@export var variableA: ExpressionResource
@export var comparator: Instruction.Comparators
@export var variableB: ExpressionResource

func getComparatorText():
	return COMPARATORS_NAMES[comparator]
