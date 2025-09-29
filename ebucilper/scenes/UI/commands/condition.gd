extends Control

@export var condition: ConditionResource

func _ready() -> void:
	$Comparator.text = condition.getComparatorText()
	if(condition.variableA):
		$VarDropSlotA.setVariable(condition.variableA)
	if(condition.variableB):
		$VarDropSlotB.setVariable(condition.variableB)


func _on_var_drop_slot_a_state_changed() -> void:
	if $VarDropSlotA.variable != null:
		condition.variableA = $VarDropSlotA.variable
	else:
		condition.variableA = $VarDropSlotA.content


func _on_var_drop_slot_b_state_changed() -> void:
	if $VarDropSlotB.variable != null:
		condition.variableB = $VarDropSlotB.variable
	else:
		condition.variableB = $VarDropSlotB.content
