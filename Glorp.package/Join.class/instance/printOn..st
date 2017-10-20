printing
printOn: aStream

	sources with: targets do: [:source :target |
		aStream nextPut: $(.
		source printSQLOn: aStream withParameters: #().
		aStream nextPutAll: ' = '.
		target printSQLOn: aStream withParameters: #().
		aStream nextPutAll: ') ']