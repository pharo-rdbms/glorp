create/delete in db
dropFromAccessor: aDatabaseAccessor
	aDatabaseAccessor platform supportsConstraints
		ifTrue: [self dropPrimaryKeyConstraintsFromAccessor: aDatabaseAccessor].
	aDatabaseAccessor dropTableNamed: self name.