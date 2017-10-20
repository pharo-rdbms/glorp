obsolete
addFields: aCollection fromAccessor: aDatabaseAccessor
	| stream |
	aCollection
		do:
			[:each | 
			aDatabaseAccessor
				execute:
					[stream := WriteStream on: String new.
					stream
						nextPutAll: 'ALTER TABLE ';
						nextPutAll: self name;
						nextPutAll: ' ADD ';
						nextPutAll: self platform startColumnAddString.
					self platform printColumn: each on: stream.
					stream nextPutAll: self platform endColumnAddString.
					aDatabaseAccessor executeSQLStringNoResult: stream contents]
				ifError: [:ex | ex pass]].