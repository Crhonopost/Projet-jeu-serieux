class_name LevelResource extends Resource

@export var id: String
@export var name: String
@export var texts : Array[DialogResource]
@export var background: Texture2D
@export var to_be_done_icon: Texture2D
@export var completed_icon: Texture2D


@export_multiline var tip: String
@export var authorized_logic_executions := AuthorizedInstructions.new()


@export var target_steps: int
@export var optimal_steps: int
@export var steps: int # ?
@export var unlocked : bool
@export var done: bool


@export var build_data := BuildResource.new()
