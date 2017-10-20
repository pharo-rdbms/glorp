printing SQL
printMicrosoftOuterJoinOn: aCommand
	self isOuterJoin ifFalse: [^self].
	aCommand platform useMicrosoftOuterJoins ifTrue: [
		aCommand nextPutAll: '*'].