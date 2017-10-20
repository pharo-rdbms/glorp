private
readBackModelWithValue: anObject
	"For SQL-Server, use CONVERT (which is easier than CAST for now), with = instead of LIKE."

	^ self useEqualityToCompare
		ifTrue: [ | converted |
			converted := self platform isSQLServerPlatform ifTrue: [ self convertToTypeFrom: anObject ] ifFalse: [ anObject ].
			session
				readOneOf: GlorpTypeTestsModelClass
				where: [ :each | each test = converted ] ]
		ifFalse: [ session
				readOneOf: GlorpTypeTestsModelClass
				where: [ :each | each test like: anObject ] ]

	"^session
		readOneOf: GlorpTypeTestsModelClass
		where: [:each | each test like: (Cast value: anObject as: type queryType)]."