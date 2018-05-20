conversion-boolean
convertIntegerToBoolean: anInteger for: aType

	"UDBC SQLite transparently returns Smalltalk true/false/nil for SQL columns declared as boolean."
	^ (anInteger isKindOf: Boolean)
		ifTrue: [ anInteger ]
		ifFalse: [ super convertIntegerToBoolean: anInteger for: aType ]
