obsolete
dropFields: aCollection fromAccessor: aDatabaseAccessor
	aCollection
		do:
			[:each | 
			aDatabaseAccessor
				execute:
					[aDatabaseAccessor
						executeSQLStringNoResult:
							'ALTER TABLE ' , self name , ' DROP COLUMN ' , each name]
				ifError: [:ex | ex pass]].