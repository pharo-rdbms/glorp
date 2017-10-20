printing
generateName
	"Generate a name for this index that will fit within the size limits of the database. This only takes into account the first field being used. If there's more than one that has multiple columns and the same first one, then the user will have to manually provide a name"

	| stream maxLength tableLength roomToBeVerbose minTableLength maxTableLength |
	maxLength := fields first table platform maximumLengthOfTableName.
	minTableLength := ((maxLength - 8) // 2) min: 10.
	maxTableLength := (maxLength // 2) - 1.
	roomToBeVerbose := minTableLength >= 10.
	tableLength := roomToBeVerbose ifTrue: [maxTableLength] ifFalse: [minTableLength].

	stream := WriteStream on: (String new: 100).
	stream nextPutAll: (fields first table name copyFrom: 1 to: ((fields first table name size) min: tableLength)).
	stream nextPutAll: '_'.
	stream nextPutAll: (fields first name copyFrom: 1 to: ((fields first name size) min: tableLength)).
	stream nextPutAll: (maxLength - stream position >= 4 ifTrue: ['_IDX'] ifFalse: ['X']).
	^stream contents.