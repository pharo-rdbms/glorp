accessing
currentServerUTCTimestampOrNil
	"This is kind of ugly, but it is Smalltalk Dialect neutral"

	| sqlString result |
	sqlString := [self platform sqlTextCurrentServerUTCTimestamp]
		on: Dialect error
		do:  [:exception | exception return: nil].
	sqlString == nil ifTrue: [^nil].
	result := [self accessor executeSQLString: sqlString]
		on: Dialect error
		do:  [:exception | exception return: nil].
	^result == nil
		ifTrue: [nil]
		ifFalse: 
			[(result first isEmpty or: [(result first first isKindOf: Dialect timestampClass) not])
				ifTrue: [nil]
				ifFalse: [result first first]]