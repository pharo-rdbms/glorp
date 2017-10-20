obsolete
primaryKeyUniqueConstraintName
	^self platform usesPrimaryKeyUniqueConstraintNames ifTrue: [self name, '_UNIQ'] ifFalse: [''].