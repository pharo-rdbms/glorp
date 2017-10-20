printing SQL
printSQLOn: aStream withParameters: aDictionary 
	| command toPrint |
	toPrint := relation = #noneSatisfy: ifTrue: ['NOT EXISTS ('] ifFalse: [' EXISTS ('].
	aStream nextPutAll: toPrint.
	command := self query sqlWith: aDictionary.
	aStream nextPutAll: command sqlString.
	aStream nextPutAll: ')'.