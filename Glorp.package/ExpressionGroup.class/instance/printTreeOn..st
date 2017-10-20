printing
printTreeOn: aStream

	children do: [:each |
		aStream nextPut: $(.
		each printOn: aStream.
		aStream nextPut: $).
		aStream cr].