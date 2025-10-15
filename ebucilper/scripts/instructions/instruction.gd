@abstract
class_name Instruction

enum Comparators {SUPERIOR, INFERIOR, EQUAL}
enum Operators {ADD, SUB, MULT, DIV, MOD}

static func operatorToStr(op: Operators) -> String:
	match op:
		Operators.ADD:
			return "+"
		Operators.MULT:
			return "*"
		Operators.SUB:
			return "-"
		Operators.DIV:
			return "/"
		Operators.MOD:
			return "%"
	
	return "????"

@abstract
func hasArg() -> bool
