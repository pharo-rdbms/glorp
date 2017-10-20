navigating
ultimateBaseExpression

	^leftChild canHaveBase ifTrue: [leftChild ultimateBaseExpression] ifFalse: [rightChild ultimateBaseExpression].