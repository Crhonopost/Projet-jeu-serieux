class_name ConditionResource extends Resource

var COMPARATORS_NAMES = {
	Instruction.Comparators.SUPERIOR: ">",
	Instruction.Comparators.INFERIOR: "<",
	Instruction.Comparators.EQUAL: "=="
}

@export var variableA: VariableResource
@export var comparator: Instruction.Comparators
@export var variableB: VariableResource

func getComparatorText():
	return COMPARATORS_NAMES[comparator]
