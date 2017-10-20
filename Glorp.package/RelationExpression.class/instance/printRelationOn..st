printing SQL
printRelationOn: aStream
	aStream space.
	self printMicrosoftOuterJoinOn: aStream.
	aStream 
		nextPutAll: self relation;
		space.