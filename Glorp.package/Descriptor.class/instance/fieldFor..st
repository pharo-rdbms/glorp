creating mappings
fieldFor: aFieldOrString
	"We allow either a field or a string naming the field, and return the appropriate field object."
	aFieldOrString isString ifFalse: [^aFieldOrString].
	self tables do: [:each |
		| field | 
		field := each fieldNamed: aFieldOrString.
		field isNil ifFalse: [^field]].
	self error: 'Cannot find field ', aFieldOrString, '. Please pass in the field object'