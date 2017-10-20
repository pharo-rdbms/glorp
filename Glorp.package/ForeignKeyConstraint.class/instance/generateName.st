printing
generateName
	| stream maxLength tableLength roomToBeVerbose shortTableLength longTableLength |
	self sourceFields isEmpty ifTrue: [^'INVALID CONSTRAINT'].
	"Figure out if we have room for verbose separators or if we should maximize the space for the table/field names"
	maxLength := self sourceFields first table platform maximumLengthOfTableName.
	shortTableLength := ((maxLength - 8) // 2) min: 10.
	longTableLength := (maxLength // 2) - 1.
	roomToBeVerbose := shortTableLength >= 10.
	tableLength := roomToBeVerbose ifTrue: [shortTableLength] ifFalse: [longTableLength].

	stream := WriteStream on: (String new: 100).
	self printForConstraintName: self sourceFields first on: stream maxLength: tableLength.
	roomToBeVerbose ifTrue: [stream nextPutAll: '_TO_'].
	self printForConstraintName: self targetFields first on: stream maxLength: tableLength.
	stream nextPutAll: (roomToBeVerbose ifTrue: ['_REF'] ifFalse: ['R']).
	^stream contents.