printing SQL
printWithNullOn: aStream
	aStream nextPutAll: ' IS '.
	self relation = #<> ifTrue: [
		aStream nextPutAll: 'NOT '].
	aStream nextPutAll: 'NULL'.