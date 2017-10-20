accessing
generateName
	| stream maxLength tableLength roomToBeVerbose shortTableLength longTableLength |
	(self fields isNil or: [self fields isEmpty]) ifTrue: [^'INVALID CONSTRAINT'].
	"Figure out if we have room for verbose separators or if we should maximize the space for the table/field names"
	maxLength := self fields first table platform maximumLengthOfTableName.
	shortTableLength := ((maxLength - 7) // 2) min: 10.
	longTableLength := (maxLength - 7).
	roomToBeVerbose := shortTableLength >= 10.
	tableLength := roomToBeVerbose ifTrue: [longTableLength] ifFalse: [shortTableLength].

	stream := WriteStream on: (String new: 100).
	self printForConstraintNames: self fields on: stream maxLength: tableLength.
	stream nextPutAll: (roomToBeVerbose ifTrue: ['_UNIQ'] ifFalse: ['U']).
	^stream contents.