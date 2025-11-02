class_name FunctionLogicResource extends ListLogicResource

@export var name: String
@export var args: PackedStringArray

signal updateArgsCount(newCount: int)
signal updateArgName(argIdx: int, newName: String)
signal updateFuncName(newName: String)

func addArg():
	args.append("x")
	emit_signal("updateArgsCount", args.size())

func setArgName(argIdx: int, argName: String):
	args[argIdx] = argName
	emit_signal("updateArgName", argIdx, argName)

func deleteArg(index: int):
	args.remove_at(index)
	emit_signal("updateArgsCount", args.size())

func setName(newName: String):
	name = newName
	emit_signal('updateFuncName', newName)

func buildName(n: String) -> FunctionLogicResource:
	name = n
	return self
