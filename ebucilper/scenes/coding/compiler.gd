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
	
	elif(entryPoint is FlowInstructionResource):    
		var flowContent : Array[Instruction]
		
		var endLoopCondition := Instruction.new()
		endLoopCondition.action = InstructionType.JUMP_IF_NOT
		endLoopCondition.arguments = {
			"variable_a" = entryPoint.condition.variableA,
			"variable_b" = entryPoint.condition.variableB,
			"comparator" = entryPoint.condition.comparator
		}
		
		for child in entryPoint.childs:
			flowContent.append_array(processInstructions(child, instructionIdx + flowContent.size()))
		
		if(entryPoint is ForInstructionResource):
			endLoopCondition.arguments["jump_index"] = instructionIdx + flowContent.size() + 2
			flowContent.append(endLoopCondition)
			
			var jumpBackInstruction:= Instruction.new()
			jumpBackInstruction.action = InstructionType.JUMP
			jumpBackInstruction.arguments["jump_index"] = instructionIdx
			flowContent.append(jumpBackInstruction)
		
		res.append_array(flowContent)
	
	return res
