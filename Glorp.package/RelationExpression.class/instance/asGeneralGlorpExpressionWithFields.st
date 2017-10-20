converting
asGeneralGlorpExpressionWithFields
	"Convert the result to a general (tree-format) expression, if it's the more limited join expression."
	| result |
	result := self copy.
	result leftChild: leftChild asGeneralGlorpExpressionWithFields.
	result rightChild: rightChild asGeneralGlorpExpressionWithFields.
	^result.