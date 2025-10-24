class_name LowLevelExpression

var variables : PackedStringArray
var expression := Expression.new()

func parse(expr: String) -> void:
	variables = extract_variables(expr)
	expression.parse(expr, variables)

func execute(runtimesVars: Dictionary) -> Variant:
	var inputs := []
	for v in variables:
		inputs.append(runtimesVars[v])
	return expression.execute(inputs)

const reserved_words: PackedStringArray = [
	
]

func extract_variables(expr: String) -> PackedStringArray:
	var regex = RegEx.new()
	# Capture tout mot commençant par lettre ou underscore, suivi de lettres/chiffres/underscore
	regex.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\b")
	var matches = regex.search_all(expr)
	var vars = []
	for m in matches:
		var name = m.get_string(1)
		# filtrer s’il s’agit d’un mot réservé ou d’un nombre, ou d’une fonction connue
		if reserved_words.has(name):
			continue
		# optionnel : filtrer s’il s’agit d’un nombre (mais ici on ne le captera pas)
		# ajouter s’il n’est pas déjà dans la liste
		if not vars.has(name):
			vars.append(name)
	return vars
