services constraints
writeConstraintToDrop: aConstraint onStream: aStream
	aStream
		nextPutAll: 'CONSTRAINT ';
		nextPutAll: aConstraint name.