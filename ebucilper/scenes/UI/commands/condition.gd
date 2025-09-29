extends Control

@export var condition: ConditionResource

func _ready() -> void:
	$VarA.text = str(condition.variableA)
	$Comparator.text = condition.getComparatorText()
	$VarB.text = str(condition.variableB)
