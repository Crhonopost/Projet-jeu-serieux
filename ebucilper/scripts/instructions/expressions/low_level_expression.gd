class_name LowLevelExpression extends Node

enum OperatorEnum {ADD, SUB, MULT, DIV, MOD, SUPE, INFE, EQUA, NONE}

static func operatorToStr(op: OperatorEnum) -> String:
	match op:
		OperatorEnum.ADD:
			return "+"
		OperatorEnum.MULT:
			return "*"
		OperatorEnum.SUB:
			return "-"
		OperatorEnum.DIV:
			return "/"
		OperatorEnum.MOD:
			return "%"
		OperatorEnum.INFE:
			return "<"
		OperatorEnum.SUPE:
			return ">"
		OperatorEnum.EQUA:
			return "=="
		OperatorEnum.NONE:
			return ""
	
	return "????"

static func execute(operandA: int, op: OperatorEnum, operandB: int) -> int:
	match op:
		OperatorEnum.ADD:
			return operandA + operandB
		OperatorEnum.MULT:
			return operandA * operandB
		OperatorEnum.SUB:
			return operandA - operandB
		OperatorEnum.DIV:
			return operandA / operandB
		OperatorEnum.MOD:
			return operandA % operandB
		OperatorEnum.INFE:
			return operandA < operandB
		OperatorEnum.SUPE:
			return operandA > operandB
		OperatorEnum.EQUA:
			return operandA == operandB
	
	return 0

var A : Variant
var operator: OperatorEnum
var B : Variant
