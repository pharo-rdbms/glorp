printing SQL
printValue: value on: aCommand
	| type |
	type := [self leftChild type] on: Dialect error do: [:ex | self error: 'Invalid comparison operation: ', self printString].
	(self useBindingFor: value to: type in: aCommand) ifTrue: [^aCommand nextPutAll: '?'].
	self expectsCollectionArgument
		ifTrue:
			[type
				printCollection: value
				on: aCommand]
		ifFalse:
			[type
				print: value
				on: aCommand].