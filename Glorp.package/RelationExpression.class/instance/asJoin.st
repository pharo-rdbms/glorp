converting
asJoin
	| leftField rightField |
	leftField := self leftChild field.
	rightField := self rightChild field.
	(leftField notNil and: [rightField notNil]) ifTrue: [^Join from: leftField to: rightField].
	^leftChild asJoin, rightChild asJoin.