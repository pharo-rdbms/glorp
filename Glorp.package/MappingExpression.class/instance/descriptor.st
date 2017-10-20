accessing
descriptor
	| system theMapping |
	system := self system.
	system isNil ifTrue: [^nil].
	theMapping := self mappingFromMeOrSubclasses.
	theMapping isNil ifTrue: [^nil].
	^system descriptorFor: theMapping referenceClass.