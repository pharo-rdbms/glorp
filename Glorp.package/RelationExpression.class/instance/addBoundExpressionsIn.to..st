preparing
addBoundExpressionsIn: aCommand to: boundExpressions
	"If our right-child can be used for binding, add it to the list. We need to do this at this level because the expressions themselves don't know what type they'll be matched against"

	| translated |
	rightChild canBind ifFalse: [^self].
	(boundExpressions includes: self) ifTrue: [^self].
	translated := self convertValueOf: rightChild in: aCommand parameters.
	(self useBindingFor: translated to: leftChild type in: aCommand) ifTrue: [boundExpressions add: self].