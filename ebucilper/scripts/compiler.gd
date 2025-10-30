extends  Node

const InstructionType = NoArgsInstruction.NoArgInstructionType

var functionCallsWaiting : Dictionary[int, String]
var functionsCallWaitingArgs : Dictionary[int, PackedStringArray]

func processAllInstructions(entryPoints: Array[FunctionLogicResource]) -> Array[Instruction]:
	var functions: Dictionary[String, int]
	var functionsArgs: Dictionary[int, PackedStringArray]
	
	var res : Array[Instruction]
	for entry in entryPoints:
		functions[entry.name] = res.size()
		functionsArgs[res.size()] = entry.args
		res.append_array(processInstructions(entry, res.size()))
		var endInstruction := NoArgsInstruction.new()
		endInstruction.action = InstructionType.EXIT_FUNCTION
		res.append(endInstruction)
	
	for fctCall in functionCallsWaiting.keys():
		var fctIdx = functions[functionCallsWaiting[fctCall]]
		res[fctCall].jumpIdx = fctIdx
		for argIdx in range(functionsArgs[fctIdx].size()):
			var varExpression := functionsCallWaitingArgs[fctCall].get(argIdx)
			var argName := functionsArgs[fctIdx][argIdx]
			var llExpression = LowLevelExpression.new()
			llExpression.parse(varExpression)
			res[fctCall].argsToVar[argName] = llExpression
	
	return res

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
		
		elif entryPoint is CallFunctionLogicResource:
			instru = CallFunctionInstruction.new()
			functionCallsWaiting[instructionIdx] = entryPoint.targetFunction.name
			functionsCallWaitingArgs[instructionIdx] = entryPoint.args
			
		
		elif entryPoint is CreateLogicResource:
			instru = CreateVarInstruction.new()
			instru.expression.parse(entryPoint.value)
			#instru.expression.A = entryPoint.value
			#instru.expression.operator = LowLevelExpression.OperatorEnum.NONE
			instru.target = entryPoint.name
		
		elif entryPoint is ChangeColorLogicResource:
			instru = ChangeColorInstruction.new()
			instru.color = entryPoint.color
		
		elif entryPoint is SetCursorPositionLogicResource:
			instru = SetCursorPositionInstruction.new()
			instru.position_x.parse(entryPoint.position_x)
			instru.position_y.parse(entryPoint.position_y)
			instru.position_z.parse(entryPoint.position_z)
		
		return [instru]
	
	elif(entryPoint is ListLogicResource):    
		var instructionList : Array[Instruction]
		
		if entryPoint is WhileLogicResource:
			instructionList.append_array(processWhile(entryPoint, instructionIdx))
		elif entryPoint is ForLogicResource:
			instructionList.append_array(processFor(entryPoint, instructionIdx))
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
	

func processFor(forLogic: ForLogicResource, instructionIdx: int) -> Array[Instruction]:
	var res : Array[Instruction]
	
	var iteratorCreation := CreateVarInstruction.new()
	iteratorCreation.target = forLogic.variableName
	iteratorCreation.expression.parse("0")
	res.append(iteratorCreation)
	
	################ jump condition #####################
	var endLoopCondition := JumpToIfInstruction.new()
	endLoopCondition.evaluateNot = true
	endLoopCondition.condition.parse(forLogic.variableName + "<" + forLogic.stepCount)
	res.append(endLoopCondition)
	#####################################
	
	################# childs ####################
	var iteratorUpdate := UpdateVarInstruction.new()
	iteratorUpdate.target = forLogic.variableName
	iteratorUpdate.expression.parse(forLogic.variableName + " + 1")
	res.append(iteratorUpdate)
	
	for child in forLogic.childs:
		res.append_array(processInstructions(child, instructionIdx + res.size()))
	#####################################
	
	################# jump back ####################
	var jumpBackInstruction:= JumpToInstruction.new()
	jumpBackInstruction.toIdx = instructionIdx + 1
	res.append(jumpBackInstruction)
	#####################################
	
	endLoopCondition.toIdx = instructionIdx + res.size()
	
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
