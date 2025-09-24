extends Command

@export var instruction: InstructionType

@onready var instructionLabel = $HBoxContainer/VBox/Label
@onready var instructionTypes = $HBoxContainer/VBox/ExecuctionTypes

var INSTRUCTION_NAMES = {
	InstructionType.PLACE_BLOCK: "PLACE_BLOCK",
	InstructionType.MOVE_FORWARD: "MOVE_FORWARD",
	InstructionType.MOVE_UP: "MOVE_UP",
	InstructionType.MOVE_DOWN: "MOVE_DOWN",
	InstructionType.ROTATE_LEFT: "ROTATE_LEFT",
	InstructionType.ROTATE_RIGHT: "ROTATE_RIGHT"
}


func _ready() -> void:
	for instru in InstructionType.keys():
		var instructionButton = Button.new()
		var val = InstructionType[instru]
		instructionButton.text = instru
		instructionButton.connect("pressed", func(): setInstruction(val))
		instructionTypes.add_child(instructionButton)
	
	instructionTypes.visible = false
	


func retrieveCommand() -> Array[InstructionType]:
	return [instruction]

func setInstruction(type: InstructionType):
	instructionLabel.set_text(INSTRUCTION_NAMES[type])
	instruction = type
	instructionTypes.visible = false


func _on_show_types_pressed() -> void:
	instructionTypes.visible = true


func _on_delete_pressed() -> void:
	queue_free()
