extends  Node

const InstructionType = NoArgsInstruction.NoArgInstructionType

func processInstructions(entryPoint: LogicResource, instructionIdx: int) -> Array[Instruction]:
	var res : Array[Instruction]

	if(entryPoint is UpdateLogicResource):
		var update = UpdateVarInstruction.new()
		update.target = entryPoint.name
		update.expression.parse(entryPoint.expression)
		res.append(update)
	elif(entryPoint is ExecutionLogicResource):
		var instru: Instruction
		if(entryPoint is NoArgsLogicResource):
			instru = NoArgsInstruction.new()
			instru.action = entryPoint.type
		
		elif entryPoint is CreateLogicResource:
			instru = CreateVarInstruction.new()
			instru.expression.parse(entryPoint.value)
			#instru.expression.A = entryPoint.value
			#instru.expression.operator = LowLevelExpression.OperatorEnum.NONE
			instru.target = entryPoint.name
		
		elif entryPoint is ChangeColorLogicResource:
			instru = ChangeColorInstruction.new()
			instru.color = entryPoint.color
		
		return [instru]
	
	elif(entryPoint is ListLogicResource):    
		var instructionList : Array[Instruction]
		
		if entryPoint is WhileLogicResource:
			instructionList.append_array(processWhile(entryPoint, instructionIdx))
		elif entryPoint is FlowLogicResource:
			instructionList.append_array(processIf(entryPoint, instructionIdx))
		else:
			for child in entryPoint.childs:
				instructionList.append_array(processInstructions(child, instructionIdx + instructionList.size()))
		
		res.append_array(instructionList)
	return res

func processIf(ifLogic: FlowLogicResource, instructionIdx: int) -> Array[Instruction]:
	var res : Array[Instruction]
	
	var jumpIfCondition := JumpToIfInstruction.new()
	jumpIfCondition.evaluateNot = true
	jumpIfCondition.condition.parse(ifLogic.condition)
	res.append(jumpIfCondition)
	
	for child in ifLogic.childs:
		res.append_array(processInstructions(child, instructionIdx + res.size()))
	
	jumpIfCondition.toIdx = instructionIdx + res.size()
	
	return res
	

func processWhile(whileLogic: WhileLogicResource, instructionIdx: int) -> Array[Instruction]:
	var res : Array[Instruction]
	
	################ jump condition #####################
	var endLoopCondition := JumpToIfInstruction.new()
	endLoopCondition.evaluateNot = true
	endLoopCondition.condition.parse(whileLogic.condition)
	res.append(endLoopCondition)
	#####################################
	
	################# childs ####################
	for child in whileLogic.childs:
		res.append_array(processInstructions(child, instructionIdx + res.size()))
	#####################################
	
	################# jump back ####################
	var jumpBackInstruction:= JumpToInstruction.new()
	jumpBackInstruction.toIdx = instructionIdx
	res.append(jumpBackInstruction)
	#####################################
	
	endLoopCondition.toIdx = instructionIdx + res.size()
	
	return res
