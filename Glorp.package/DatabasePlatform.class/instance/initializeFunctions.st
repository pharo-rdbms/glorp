functions
initializeFunctions
	"Subclasses should override to add database-specific functions"

	functions := FunctionExpression createBasicFunctionsFor: self.