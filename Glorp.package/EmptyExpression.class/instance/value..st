accessing
value: aValue
	"a value is expected to be nil, true, or false. we treat nil as true"
	value := aValue isNil ifTrue: [true] ifFalse: [aValue].