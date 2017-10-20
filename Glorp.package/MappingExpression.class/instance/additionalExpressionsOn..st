preparing
additionalExpressionsOn: anExpression
	"We can get hijacked, so pass in the expression to use rather than just using self"
	| exp |
	self mapping isNil ifTrue: [^#()].
	exp := self mapping joinExpressionFor: anExpression.
	outerJoin ifTrue: [exp beOuterJoin].
	^(self multipleTableExpressionsOn: anExpression), (exp isNil ifTrue: [#()] ifFalse: [Array with: exp]).