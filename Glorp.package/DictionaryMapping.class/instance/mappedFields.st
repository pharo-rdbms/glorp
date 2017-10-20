accessing
mappedFields
	"Return a collection of fields that this mapping will write into any of the containing object's rows"

	| fields |
	fields := super mappedFields copy.
	fields addAll: keyMapping mappedFields.
	valueMapping isNil ifFalse: [
		fields addAll: valueMapping mappedFields].
	^fields