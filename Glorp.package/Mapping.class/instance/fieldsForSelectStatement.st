accessing
fieldsForSelectStatement
	"Return a collection of fields that this mapping will read from a row"
	self canRead ifFalse: [^#()].
	^self mappedFields