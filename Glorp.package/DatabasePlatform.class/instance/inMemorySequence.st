types
inMemorySequence
	^self typeNamed: #inMemorySequence ifAbsentPut: [
		GlorpInMemorySequenceDatabaseType representedBy: self int4].