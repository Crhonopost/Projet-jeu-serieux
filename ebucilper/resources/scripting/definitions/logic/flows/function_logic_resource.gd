class_name FunctionLogicResource extends ListLogicResource

@export var name: String
@export var args: PackedStringArray

signal updateArgsCount(newCount: int)
signal updateArgName(argIdx: int, newName: String)

func addArg():
	args.append("x")
	emit_signal("updateArgsCount", args.size())

func deleteArg(index: int):
	args.remove_at(index)
	emit_signal("updateArgsCount", args.size())
