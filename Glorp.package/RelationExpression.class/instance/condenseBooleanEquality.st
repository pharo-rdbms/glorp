preparing
condenseBooleanEquality
	(relation = #AND | (relation = #OR)) ifFalse: [^self].
	(leftChild isGlorpExpression and: [leftChild isConstantExpression])
		ifTrue: [
			(relation = #AND and: [leftChild value = true]) ifTrue: [^rightChild].
			(relation = #AND and: [leftChild value = false]) ifTrue: [^leftChild].
			(relation = #OR and: [leftChild value = true]) ifTrue: [^leftChild].
			(relation = #OR and: [leftChild value = false]) ifTrue: [^rightChild]].
	(rightChild isGlorpExpression and: [rightChild isConstantExpression])
		ifTrue: [
			(relation = #AND and: [rightChild value = true]) ifTrue: [^leftChild].
			(relation = #AND and: [rightChild value = false]) ifTrue: [^rightChild].
			(relation = #OR and: [rightChild value = true]) ifTrue: [^rightChild].
			(relation = #OR and: [rightChild value = false]) ifTrue: [^leftChild]].

	^self.