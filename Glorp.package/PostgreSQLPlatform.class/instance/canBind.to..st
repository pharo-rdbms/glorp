testing
canBind: aValue to: aType
	"In 7.10, the Postgres protocol 2.0 EXDI can accept Timestamp and Number formats for binding.  Date and time formats have not yet been handled."

	aType = self date ifTrue: [^false].
	aType = self time ifTrue: [^false].
	aType = self timetz ifTrue: [^false].
	^super canBind: aValue to: aType