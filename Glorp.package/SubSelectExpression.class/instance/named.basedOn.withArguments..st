internal
named: aSymbol basedOn: anExpression withArguments: anArray

	| right |
	outerJoin := false.
	relation := self operationFor: aSymbol.
	leftChild := anExpression base.

	localBase := SubSelectBaseExpression on: anExpression.
	right := anArray first.
	rightChild := right rebuildOn: localBase startingFrom: anExpression.