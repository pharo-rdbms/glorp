accessing
arrayBoundFields
	"For a delete, it makes no difference, we only ever include the primary key fields"
	^self singleRowBoundFields.