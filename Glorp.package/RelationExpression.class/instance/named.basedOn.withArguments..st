private/initializing
named: aSymbol basedOn: anExpression withArguments: anArray

	| base right rightBase |
	outerJoin := false.
	relation := self operationFor: aSymbol.
	leftChild := anExpression.

	"The only time we don't expect anExpression to have a base is if it's a constant, in which case the other side should be a variable expression and thus have a base."
	base := anExpression canHaveBase ifTrue: [anExpression ultimateBaseExpression] ifFalse: [anArray first ultimateBaseExpression].
	right := anArray first.
	right isGlorpExpression ifFalse: [rightChild := right asGlorpExpressionOn: base. ^self].
	rightBase := right ultimateBaseExpression.
	rightChild := rightBase ~= base
		ifTrue: [
			right asGlorpExpressionOn: ((rightBase notNil and: [rightBase hasDescriptor]) ifTrue: ["Correlated subselect" rightBase] ifFalse: [base])]
		ifFalse: [right].