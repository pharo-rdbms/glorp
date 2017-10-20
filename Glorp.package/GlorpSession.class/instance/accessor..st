accessing
accessor: aDatabaseAccessor 
	accessor := aDatabaseAccessor.
	system isNil ifFalse: [system platform: (accessor platform)]