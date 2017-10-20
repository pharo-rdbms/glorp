executing
executeSQLString: aString binding: aBindingArray
	| result block time |
	self log: aString.
	block := [ 
		result := (self basicExecuteSQLString: aString binding: aBindingArray) upToEnd].
	time := self logging
		ifTrue: [Time millisecondsToRun: block]
		ifFalse:
			[block value.
			0].
	self logTime: time.
	^result.