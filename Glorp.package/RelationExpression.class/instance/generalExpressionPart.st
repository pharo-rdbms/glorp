converting
generalExpressionPart
	| left right |
	left := leftChild generalExpressionPart.
	right := rightChild generalExpressionPart.
	(left isNil and: [right isNil]) ifTrue: [^nil].
	left isNil ifTrue: [^right].
	right isNil ifTrue: [^left].
	^self.