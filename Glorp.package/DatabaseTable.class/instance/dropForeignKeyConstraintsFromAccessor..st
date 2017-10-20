obsolete
dropForeignKeyConstraintsFromAccessor: aDatabaseAccessor 
	self foreignKeyConstraints 
		do: [:each | aDatabaseAccessor dropConstraint: each]