printing
equalityStringForField: aDatabaseField

	| stream |
	stream := WriteStream on: (String new: 50).
	self printEqualityStringForField: aDatabaseField on: stream.
	^stream contents.