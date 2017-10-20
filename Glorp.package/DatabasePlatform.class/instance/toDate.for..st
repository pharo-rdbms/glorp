conversion-times
toDate: anObject for: aType
	"SQL supports adding an integer to a date, meaning incrementing the date by that number of days, so we pass integer values here as well as dates."

	anObject isNil ifTrue: [^nil].
	anObject class = Date ifTrue: [^anObject].
	anObject isInteger ifTrue: [^anObject].
	^anObject asDate