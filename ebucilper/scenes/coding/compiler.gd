extends  Node

const InstructionType = Instruction.InstructionType

func processInstructions(entryPoint: InstructionResource) -> Array[InstructionType]:
    var res : Array[InstructionType]

    if(entryPoint is ExecutionInstructionResource):
        return [entryPoint.type]
    
    elif(entryPoint is FlowInstructionResource):    
        var flowContent : Array[InstructionType]
        for child in entryPoint.childs:
            flowContent.append_array(processInstructions(child))

        if(entryPoint is ForInstructionResource):
            for i in entryPoint.iterationCount:
                res.append_array(flowContent)
        else:
            res = flowContent 
    
    return res