extends Control

const InstructionType = Instruction.InstructionType

signal instructionChanged(InstructionType)

func _ready():
	var popup = $InstructionType.get_popup()
	popup.clear()  # Nettoyer s'il y avait des éléments avant
	
	for name in InstructionType.keys():
		popup.add_item(name)
	
	popup.id_pressed.connect(onInstructionSelected)

func onInstructionSelected(index):
	emit_signal("instructionChanged", index)
