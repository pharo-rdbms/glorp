building objects
canBuild
	"If we have a regular object with a nil primary key, or if we have an embedded object whose values are all nil, we can't build anything (probably due to an outer join)"
	^self descriptor mapsPrimaryKeys
		ifTrue: [self key notNil]
		ifFalse: [true]