converting
asGeneralGlorpExpression
	"Convert the result to a general (tree-format) expression, if it's the more limited join expression."
	| result |
	result := self copy.
	result leftChild: leftChild asGeneralGlorpExpression.
	result rightChild: rightChild asGeneralGlorpExpression.
	^result.