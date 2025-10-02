extends  Node

const InstructionType = Instruction.InstructionType

func processInstructions(entryPoint: InstructionResource, instructionIdx: int) -> Array[Instruction]:
	var res : Array[Instruction]

	if(entryPoint is ExecutionInstructionResource):
		var content := Instruction.new()
		content.action = entryPoint.type
		if(entryPoint is CreateInstructionResource):
			content.arguments["variable_name"] = entryPoint.name.value
			content.arguments["operations"] = {"variable": entryPoint.value}
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
			
			var endLoopCondition := Instruction.new()
			endLoopCondition.action = InstructionType.JUMP_IF_NOT
			endLoopCondition.arguments = {
				"variable_a" = entryPoint.condition.variableA.value,
				"variable_b" = entryPoint.condition.variableB.value,
				"comparator" = entryPoint.condition.comparator
			}
			
			endLoopCondition.arguments["jump_index"] = instructionIdx + instructionList.size() + 2
			instructionList.push_front(endLoopCondition)
		
		res.append_array(instructionList)
	
	return res
