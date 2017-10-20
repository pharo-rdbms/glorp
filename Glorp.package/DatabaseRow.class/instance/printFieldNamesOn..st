printing
printFieldNamesOn: aWriteStream 
	GlorpHelper 
		do: [:each | aWriteStream nextPutAll: each name]
		for: self table fields
		separatedBy: [aWriteStream nextPutAll: ','].