helpers
print: printBlock on: stream for: aCollection separatedBy: separatorString

	| array |
	array := aCollection asArray.
	1 to: array size do: [:index |
		stream nextPutAll: (printBlock value: (array at: index)).
		index == array size ifFalse: [
			stream nextPutAll: separatorString]]