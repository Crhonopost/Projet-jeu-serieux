class_name GridResource extends Resource

@export var gridScale : int = 10

var dimmensions: Vector3i = Vector3i(gridScale,gridScale,gridScale)

const ColorsEnum = Global.ColorsEnum

var grid: Array[ColorsEnum]
