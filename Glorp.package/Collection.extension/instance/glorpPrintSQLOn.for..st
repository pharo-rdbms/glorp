*Glorp
glorpPrintSQLOn: aStream for: aType
	aStream nextPut: $(.
	self isEmpty
		ifTrue: [aStream nextPutAll: 'NULL']
		ifFalse:
			[GlorpHelper
				do: [:each | aType print: each on: aStream]
				for: self
				separatedBy: [aStream nextPutAll: ', ']].
	aStream nextPut: $).