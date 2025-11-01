extends FlowContainer 

@export var availableInstructions : AuthorizedInstructions

@onready var instructionItemScene : PackedScene = load("res://scenes/UI/instruction_item.tscn")

func _ready() -> void:
	allow_instructions(availableInstructions)

func allow_instructions(instructions: AuthorizedInstructions):
	availableInstructions = instructions
	for child in get_children():
		child.queue_free()
	for instruction in availableInstructions.instructions:
		var invInstance = instructionItemScene.instantiate()
		invInstance.setInstruction(instruction)
		add_child(invInstance)
