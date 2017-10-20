accessing
oldVersionAt: aField ifAbsent: aBlock
	oldVersion isNil ifTrue: [^aBlock value].
	^oldVersion at: aField ifAbsent: aBlock.