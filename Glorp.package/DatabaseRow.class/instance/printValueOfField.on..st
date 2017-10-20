printing
printValueOfField: aDatabaseField on: aWriteStream 
	aDatabaseField type print: (self at: aDatabaseField ifAbsent: [nil]) on: aWriteStream.