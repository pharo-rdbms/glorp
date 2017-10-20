As yet unclassified
assembleCompositePrimaryKeyFrom: anArray and: anotherArray
	"The arrays will be the same size, and if both have non-nil values in a given slot, those values will be the same.  This is caused by the calling method; the array is the size the table's compiosite primary key must be and the values are the values are derived from the field positions."

	1 to: anotherArray size do:
		[:index || other | other := anotherArray at: index.
		other == DatabaseRow emptySlot ifFalse: [anArray at: index put: other]].
	^anArray