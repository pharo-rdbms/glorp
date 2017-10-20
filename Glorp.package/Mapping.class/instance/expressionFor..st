mapping
expressionFor: anObject
	"Return an expression representing the value of the object. This can be nil, an object value or values, an expression, or a collection of expressions (for a composite key, if we're passed an expression)"

	anObject isNil ifTrue: [^#(nil)].
	anObject isGlorpExpression ifFalse: [
		^self mappedFields collect: [:each | 	
			self valueOfField: each fromObject: anObject]].
	^self mappedFields
		collect: [:each | (anObject getField: each)]