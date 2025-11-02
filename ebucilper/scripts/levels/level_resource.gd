class_name LevelResource extends Resource

@export var id: String
@export var name: String
@export var texts : Array[DialogResource]
@export var background: Texture2D
@export var to_be_done_icon: Texture2D
@export var completed_icon: Texture2D

@export var functions: Array[FunctionLogicResource]

func _init() -> void:
	if functions.size() == 0:
		functions = [
			FunctionLogicResource.new().buildName("Main")
		]


@export_multiline var tip: String
@export var authorized_logic_executions := AuthorizedInstructions.new()


@export var optimal_steps: int
@export var player_steps: int = 999999
@export var optimal_instruction_count: int
@export var player_instruction_count: int = 999999

@export var unlocked : bool
@export var done: bool


@export var build_data := BuildResource.new()
