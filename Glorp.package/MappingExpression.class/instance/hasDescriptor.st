accessing
hasDescriptor
	"Does the object that we describe have its own descriptor"
	| myMapping |
	myMapping := self mapping.
	^myMapping notNil and: [myMapping isRelationship]