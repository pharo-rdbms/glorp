*Glorp
glorpPrintSQLOn: aCommand
	aCommand nextPut: $(.
	self isEmpty
		ifTrue: [aCommand nextPutAll: 'NULL']
		ifFalse:
			[GlorpHelper
				do: [:each | each glorpPrintSQLOn: aCommand]
				for: self
				separatedBy: [aCommand nextPutAll: ', ']].
	aCommand nextPut: $).