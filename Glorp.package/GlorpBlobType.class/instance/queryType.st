types
queryType
	"Return the type that we can cast an argument to in order to match against this"
	queryType isNil ifTrue: [^self].
	^queryType.