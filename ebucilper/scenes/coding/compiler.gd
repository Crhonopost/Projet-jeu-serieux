extends  Node

const InstructionType = Instruction.InstructionType

func processInstructions(entryPoint: InstructionResource) -> Array[Instruction]:
	var res : Array[Instruction]

	if(entryPoint is ExecutionInstructionResource):
		var content := Instruction.new()
		content.action = entryPoint.type
		return [content]
	
	elif(entryPoint is FlowInstructionResource):    
		var flowContent : Array[Instruction]
		for child in entryPoint.childs:
			flowContent.append_array(processInstructions(child))

		if(entryPoint is ForInstructionResource):
			for i in entryPoint.iterationCount:
				res.append_array(flowContent)
		else:
			res = flowContent 
	
	return res
