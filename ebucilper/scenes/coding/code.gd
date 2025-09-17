extends Control

var instructionItem : PackedScene = load("res://scenes/coding/instruction_item.tscn")

func addInstruction():
	var instance = instructionItem.instantiate()
	$List.add_child(instance)
	
func _ready() -> void:
	$Add.pressed.connect(addInstruction)
