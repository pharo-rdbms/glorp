conversion-times
toDate: anObject for: aType
	"SQLite does not handle timestamps;  all such must be treated as strings and the to... and read... formats must agree.  SQLite does use column-default-value UTC functions:
	CURRENT_DATE format YYYY-MM-DD
	CURRENT_TIME format HH:MM:SS
	CURRENT_TIMESTAMP format YYYY-MM-DD HH:MM:SS
so our string conversions must agree with these formats."

	| stream |
	anObject isNil ifTrue: [^nil].
	stream := String new writeStream.
	self
		printDate: (super toDate: anObject for: aType)
		isoFormatOn: stream.
	^stream contents