accessing
fieldFromMeOrSubclasses
	"Return the field for this mapping, but if the field is not mapped here, and the class uses inheritance, check for subclasses, and use the first subclass mapping we find."

	| subMapping |
	subMapping := self mappingFromMeOrSubclasses.
	^subMapping isNil
		ifTrue: [self field]
		ifFalse: [base translateField: subMapping field]