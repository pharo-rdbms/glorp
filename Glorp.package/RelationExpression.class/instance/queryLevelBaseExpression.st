navigating
queryLevelBaseExpression

	^leftChild canHaveBase ifTrue: [leftChild queryLevelBaseExpression] ifFalse: [rightChild queryLevelBaseExpression].