accessing
basicPrintSQLFor: aRow
	| fields |
	self nextPutAll: 'INSERT INTO '.
	aRow table printSQLOn: self withParameters: #().
	fields := self shouldUseGroupWriting
		ifTrue: [self arrayBoundFields]
		ifFalse: [aRow nonGeneratedFieldsWithValues].
	self nextPutAll: ' ('.
	GlorpHelper
		do: [:each | self nextPutAll: (self platform nameForColumn: each name)]
		for: fields
		separatedBy: [self nextPutAll: ','].
	self nextPutAll: ') '.
	self nextPutAll: ' VALUES ('.
	GlorpHelper
		do:
			[:each | 
			(self canBind: (aRow at: each ifAbsent: [nil]) to: each type)
				ifTrue: [self nextPut: $?]
				ifFalse: [aRow printValueOfField: each on: self]]
		for: fields
		separatedBy: [self nextPutAll: ','].
	self nextPutAll: ')'.