conversion-times
toTimestamp: anObject for: aType
	"SQL supports adding an integer to a date, meaning incrementing the date by that number of days.  Oracle and SQLServer use Timestamp and Date as synonyms, so we pass integer values here as well as in #toDate:for:."

	anObject isNil ifTrue: [^nil].
	anObject class = Dialect timestampClass ifTrue: [^anObject].
	anObject isInteger ifTrue: [^anObject].
	^anObject asDateAndTime