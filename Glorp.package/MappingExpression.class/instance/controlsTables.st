fields
controlsTables
	| theMapping |
	theMapping := self mappingFromMeOrSubclasses.
	theMapping isNil ifTrue: [^true].
	^theMapping controlsTables