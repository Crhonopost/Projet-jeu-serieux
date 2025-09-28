extends Node2D

@export var instructionResource: InstructionResource

@onready var visualizationSprite : Sprite2D = $Control
@onready var typeLabel: Label = $SubViewport/Control/HBoxContainer/Type
@onready var viewport: Viewport = $SubViewport

var childsInstances : Array[Node] = []

func _ready():
	buildFromResource()

func retrieveCommand() -> Array[Instruction.InstructionType]:
	return []

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion || event is InputEventMouseButton:
		var local_pos = to_local(event.position)
		var ev = event
		ev.position = local_pos
		viewport.push_input(ev)

func _on_delete_pressed() -> void:
	queue_free()

func buildFromResource():
	if(!instructionResource): return
	for child in childsInstances:
		child.queue_free()
	
	typeLabel.text = instructionResource.getName()

	if(instructionResource is FlowInstructionResource):
		var childIt = 0
		while(childIt < instructionResource.childs.size()):
			var instance = InstructionVisualBuilder.instantiate(instructionResource.childs[childIt])
			instance.translate(Vector2(50, (childIt + 1) * 50))

			add_child(instance)
			childsInstances.append(instance)

			childIt += 1
