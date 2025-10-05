extends Control

@export var condition: ConditionResource

signal conditionUpdated(condition: ConditionResource)

func _enter_tree() -> void:
	$Comparator.text = condition.getComparatorText()
	if(condition.variableA):
		$VarDropSlotA.variable = condition.variableA
	if(condition.variableB):
		$VarDropSlotB.variable = condition.variableB

func _on_var_drop_slot_a_state_changed(variable) -> void:
	condition.variableA = variable
	emit_signal("conditionUpdated", condition)


func _on_var_drop_slot_b_state_changed(variable) -> void:
	condition.variableB = variable
	emit_signal("conditionUpdated", condition)
