printing SQL
printOracleOuterJoinOn: aCommand
	self isOuterJoin ifFalse: [^self].
	(self leftChild class == self class and: [self leftChild isOuterJoin]) ifTrue: [^self].
	(self rightChild class == self class and: [self rightChild isOuterJoin]) ifTrue: [^self].
	aCommand platform useOracleOuterJoins ifTrue: [
		aCommand nextPutAll: ' (+) '].