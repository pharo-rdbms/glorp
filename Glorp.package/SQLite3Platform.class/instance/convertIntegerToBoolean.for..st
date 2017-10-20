conversion-boolean
convertIntegerToBoolean: anInteger for: aType
	"This method accomodates an error in earlier SQLite 3 dlls. For the table_info() PRAGMA, 99 means True."

	anInteger isNil ifTrue: [^anInteger].
	anInteger >= 1 ifTrue: [^true].
	anInteger = 0 ifTrue: [^false].
	self error: 'invalid boolean conversion'