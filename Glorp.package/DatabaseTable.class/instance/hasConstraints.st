testing
hasConstraints
	^self hasForeignKeyConstraints or: [self hasPrimaryKeyConstraints or: [self hasUniqueConstraints]]