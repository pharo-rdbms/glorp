internal
fieldsForSelectStatement
	"Return a collection of fields that this mapping will read from a row"
	"Return nothing, because our sub-objects will take care of adding their own fields, translated correctly through us."
	^#().