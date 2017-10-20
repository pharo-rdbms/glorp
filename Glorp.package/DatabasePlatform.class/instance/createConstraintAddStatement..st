services constraints
createConstraintAddStatement:  aConstraint
	| sqlStatementStream |
	self supportsAlterTableForConstraints ifFalse: [^''].
	aConstraint shouldCreateInDatabase ifFalse: [^''].
	self supportsConstraints
			ifTrue: [sqlStatementStream := WriteStream on: String new.
					sqlStatementStream
						nextPutAll:  'ALTER TABLE';
						space.
					self printDDLTableNameFor: aConstraint table on: sqlStatementStream.
					(aConstraint creationStringFor: self)
						do: [ :each | sqlStatementStream nextPutAll: ' ADD ', each.]
						separatedBy: [sqlStatementStream nextPut: $,].
					^sqlStatementStream contents].
	^String new