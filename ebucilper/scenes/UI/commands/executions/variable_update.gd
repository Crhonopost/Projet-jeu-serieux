extends HBoxContainer

var update := UpdateLogicResource.new()

func _enter_tree() -> void:
	$VarTarget.text = update.name
	$VarExpression.text = update.expression


func _on_var_target_text_changed(new_text: String) -> void:
	update.name = new_text


func _on_var_expression_text_changed(new_text: String) -> void:
	update.expression = new_text
