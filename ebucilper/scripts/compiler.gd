extends  Node

const InstructionType = NoArgsInstruction.NoArgInstructionType

func processInstructions(entryPoint: LogicResource, instructionIdx: int) -> Array[Instruction]:
	var res : Array[Instruction]

	if(entryPoint is UpdateLogicResource):
		entryPoint.expression.variableName = entryPoint.name.value
		res.append_array(entryPoint.expression.getInstructions())
	elif(entryPoint is ExecutionLogicResource):
		var instru: Instruction
		if(entryPoint is NoArgsLogicResource):
			instru = NoArgsInstruction.new()
			instru.action = entryPoint.type
		
		elif entryPoint is CreateLogicResource:
			instru = CreateVarInstruction.new()
			instru.expression.A = entryPoint.value
			instru.expression.operator = LowLevelExpression.OperatorEnum.NONE
			instru.target = entryPoint.name.value
		
		elif entryPoint is ChangeColorLogicResource:
			instru = ChangeColorInstruction.new()
			instru.color = entryPoint.color
		
		return [instru]
	
	elif(entryPoint is ListLogicResource):    
		var instructionList : Array[Instruction]
		
		for child in entryPoint.childs:
			instructionList.append_array(processInstructions(child, instructionIdx + 1))
		
		if(entryPoint is WhileLogicResource):
			var jumpBackInstruction:= JumpToInstruction.new()
			jumpBackInstruction.toIdx = instructionIdx
			instructionList.append(jumpBackInstruction)
			
			var conditionExpressions: Array[Instruction] = []
			var condiVarA = entryPoint.condition.variableA
			var condiVarB = entryPoint.condition.variableB
			if(condiVarA is OperationResource):
				conditionExpressions.append_array(condiVarA.getInstructions("temp1"))
				condiVarA = "temp1"
			else:
				condiVarA = condiVarA.value
			if(condiVarB is OperationResource):
				conditionExpressions.append_array(condiVarB.getInstructions("temp2"))
				condiVarB = "temp2"
			else:
				condiVarB = condiVarB.value
			
			
			var endLoopCondition := JumpToIfInstruction.new()
			endLoopCondition.evaluateNot = true
			endLoopCondition.condition.A = condiVarA
			endLoopCondition.condition.B = condiVarB
			endLoopCondition.condition.operator = entryPoint.condition.comparator
			endLoopCondition.toIdx = instructionIdx + conditionExpressions.size() + instructionList.size() + 1
			conditionExpressions.append(endLoopCondition)
			
			conditionExpressions.append_array(instructionList)
			instructionList = conditionExpressions
			
		
		res.append_array(instructionList)
	
	return res
