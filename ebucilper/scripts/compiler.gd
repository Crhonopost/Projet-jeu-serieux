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
		
		if entryPoint is WhileLogicResource:
			instructionList.append_array(processWhile(entryPoint, instructionIdx))
		else:
			for child in entryPoint.childs:
				instructionList.append_array(processInstructions(child, instructionIdx + instructionList.size()))
		
		res.append_array(instructionList)
	return res


func processWhile(whileLogic: WhileLogicResource, instructionIdx: int) -> Array[Instruction]:
	var res : Array[Instruction]

	var instructionList : Array[Instruction]
	
	################ jump condition #####################
	var condiVarA = whileLogic.condition.variableA
	var condiVarB = whileLogic.condition.variableB
	if(condiVarA is OperationResource):
		instructionList.append_array(condiVarA.getInstructions("temp1"))
		condiVarA = "temp1"
	else:
		condiVarA = condiVarA.value
	if(condiVarB is OperationResource):
		instructionList.append_array(condiVarB.getInstructions("temp2"))
		condiVarB = "temp2"
	else:
		condiVarB = condiVarB.value
	
	
	var endLoopCondition := JumpToIfInstruction.new()
	endLoopCondition.evaluateNot = true
	endLoopCondition.condition.A = condiVarA
	endLoopCondition.condition.B = condiVarB
	endLoopCondition.condition.operator = whileLogic.condition.comparator
	instructionList.append(endLoopCondition)
	#####################################
	
	################# childs ####################
	for child in whileLogic.childs:
		instructionList.append_array(processInstructions(child, instructionIdx + instructionList.size()))
	#####################################
	
	################# jump back ####################
	var jumpBackInstruction:= JumpToInstruction.new()
	jumpBackInstruction.toIdx = instructionIdx
	instructionList.append(jumpBackInstruction)
	#####################################
	
	endLoopCondition.toIdx = instructionIdx + instructionList.size()
	
	res.append_array(instructionList)
	
	return res
