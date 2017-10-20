accessing
fieldsForDescriptorSelectStatement
	"Return a collection of fields that this mapping will read from a row when the containing object is read, as opposed to when we're specifically told to use this field. Normally it amounts to the same thing."
	^self mappedFields