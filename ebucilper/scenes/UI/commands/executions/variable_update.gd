extends HBoxContainer

var update := UpdateLogicResource.new()

func _enter_tree() -> void:
	$VarDropTarget.variable = update.name
	$VarDrop.variable = update.expression


func _on_var_drop_target_state_changed(variable: ExpressionResource) -> void:
	update.name = variable


func _on_var_drop_state_changed(variable: ExpressionResource) -> void:
	update.expression = variable
