extends HBoxContainer

@export var availableInstructions : Array[LogicResource]

@onready var instructionItemScene : PackedScene = load("res://scenes/UI/instruction_item.tscn")

func _ready() -> void:
	for instruction in availableInstructions:
		var invInstance = instructionItemScene.instantiate()
		invInstance.setInstruction(instruction)
		add_child(invInstance)
