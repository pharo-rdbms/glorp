api
getMapping: aMapping named: aSymbol
	"Get an expression given the actual mapping. Only if you really know what you're doing! In this case, what we're probably doing is rewriting a parameter that's a mapped object into a set of parameters, one for each of its primary keys."
	| expression |
	expression := nil.
	aMapping mappedFields do: [:each |
		expression := (each asGlorpExpressionOn: self) AND: expression].
	^expression.