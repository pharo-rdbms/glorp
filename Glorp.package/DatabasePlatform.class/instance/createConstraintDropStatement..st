services constraints
createConstraintDropStatement: aConstraint
	| aStream |
	self supportsAlterTableForConstraints ifFalse: [^''].
	aConstraint shouldCreateInDatabase ifFalse: [^''].
	aStream := WriteStream on: (String new: 50).
	aStream nextPutAll: 'ALTER TABLE '.
	self printDDLTableNameFor: aConstraint table on: aStream.
	aStream nextPutAll: ' DROP '.
	self writeConstraintToDrop: aConstraint onStream: aStream.
	^aStream contents.