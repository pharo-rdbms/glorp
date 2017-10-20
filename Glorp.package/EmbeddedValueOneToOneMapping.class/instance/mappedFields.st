internal
mappedFields
	"Return a collection of fields that this mapping will write into any of the containing object's rows"

	fieldTranslation isNil ifFalse: [^fieldTranslation allSourceFields].
	^self referenceDescriptor mappedFields.