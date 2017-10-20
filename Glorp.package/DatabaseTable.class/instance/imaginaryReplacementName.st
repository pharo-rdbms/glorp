printing
imaginaryReplacementName
	| stream |
	stream := WriteStream on: (String new: 100).
	stream nextPut: $(.
	stream nextPutAll: (replacementSubSelect sqlWith: #()) sqlString.
	stream nextPutAll: ') '.
	^stream contents.