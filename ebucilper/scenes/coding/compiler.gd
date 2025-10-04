extends  Node

const InstructionType = Instruction.InstructionType

func processInstructions(entryPoint: InstructionResource, instructionIdx: int) -> Array[Instruction]:
	var res : Array[Instruction]

	if(entryPoint is ExecutionInstructionResource):
		var content := Instruction.new()
		content.action = entryPoint.type
		if(entryPoint is CreateInstructionResource):
			content.arguments["name"] = entryPoint.name.value
			content.arguments["value"] = entryPoint.value
		else:
			content.arguments = entryPoint.arguments
		return [content]
	
	elif(entryPoint is ListInstructionResource):    
		var instructionList : Array[Instruction]
		
		for child in entryPoint.childs:
			instructionList.append_array(processInstructions(child, instructionIdx + 1))
		
		if(entryPoint is ForInstructionResource):
			var jumpBackInstruction:= Instruction.new()
			jumpBackInstruction.action = InstructionType.JUMP
			jumpBackInstruction.arguments["jump_index"] = instructionIdx
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
			
			
			var endLoopCondition := Instruction.new()
			endLoopCondition.action = InstructionType.JUMP_IF_NOT
			endLoopCondition.arguments = {
				"variable_a" = condiVarA,
				"variable_b" = condiVarB,
				"comparator" = entryPoint.condition.comparator
			}
			
			endLoopCondition.arguments["jump_index"] = instructionIdx + conditionExpressions.size() + instructionList.size() + 2
			conditionExpressions.append(endLoopCondition)
			
			conditionExpressions.append_array(instructionList)
			instructionList = conditionExpressions
			
		
		res.append_array(instructionList)
	
	return res
