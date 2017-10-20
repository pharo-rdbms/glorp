sql generation
printSelectFields: aCollection on: stream 
	| fieldsToPrint |
	(aCollection anySatisfy: [:each | each isDistinct]) 
		ifTrue: [
			fieldsToPrint := aCollection collect: [:each | each asField].
			stream nextPutAll: 'DISTINCT ']
		ifFalse: [fieldsToPrint := aCollection].

	"For SQL Server, the TOP has to come after the distinct, but before the fields"
	self printPreLimitOn: stream.
			
	GlorpHelper 
		do: [:field | field printSelectSQLOn: stream withParameters: nil. ]
		for: fieldsToPrint
		separatedBy: [stream nextPutAll: ', ']