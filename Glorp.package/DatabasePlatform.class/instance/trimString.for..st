conversion-strings
trimString: aString for: aType 
	| trimmedString length excess |
	aType width isNil ifTrue: [^aString].
	self measuresStringFieldWidthsInBytes ifFalse: [
		^aString size > aType width ifTrue: [aString copyFrom: 1 to: aType width] ifFalse: [aString]].
	"If our characters are less than half the number of bytes it can hold, assume it will fit and don't try to do this"
	(aString size < (aType width // 2)) ifTrue: [^aString].
	"If we're doing defaults that don't map characters to multi-bytes, don't do this"
	(#(ascii default) includes: self characterEncoding) ifTrue: [
		^aString size > aType width ifTrue: [aString copyFrom: 1 to: aType width] ifFalse: [aString]].
	trimmedString := aString.
	[length := (Dialect convert: trimmedString toByteArrayWithEncoding: self characterEncoding) size.
	excess := length - aType width.
	excess > 0 
		"Try to be careful and trim as little as possible, while still keeping the number of steps reasonable for large excesses"
		ifTrue: [trimmedString := trimmedString copyFrom: 1 to: trimmedString size - ((excess // 2) max: 1)]
		ifFalse: [^trimmedString].
	true] whileTrue.