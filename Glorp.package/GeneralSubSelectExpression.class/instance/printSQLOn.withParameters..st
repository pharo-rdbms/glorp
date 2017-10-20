printing
printSQLOn: aStream withParameters: aDictionary 
	| command |
	aStream nextPutAll: '('.
	self query session: aStream query session.
	command := self query sqlWith: aDictionary.
	aStream nextPutAll: command sqlString.
	aStream nextPutAll: ')'.