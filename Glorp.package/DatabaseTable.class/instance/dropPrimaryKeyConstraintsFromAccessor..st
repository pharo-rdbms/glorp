obsolete
dropPrimaryKeyConstraintsFromAccessor: aDatabaseAccessor
	(self primaryKeyFields isEmpty not and: [self platform usesPrimaryKeyUniqueConstraintNames])
		ifTrue: [
			aDatabaseAccessor	execute:
				[aDatabaseAccessor
						executeSQLStringNoResult:
							'ALTER TABLE ' , self name , ' DROP '
								, self platform nameForPrimaryKeyConstraintsWhenDropping , ' '
								, self primaryKeyUniqueConstraintName]
				ifError:
					[:ex | 
					Transcript show: ex messageText.
					ex return: nil].
		aDatabaseAccessor execute: [
			aDatabaseAccessor executeSQLStringNoResult:
					'ALTER TABLE ' , self name , ' DROP '
						, self platform nameForPrimaryKeyConstraintsWhenDropping , ' '
						, self primaryKeyConstraintName]
			ifError: [:ex | 
				Transcript show: ex messageText.
				ex return: nil]].