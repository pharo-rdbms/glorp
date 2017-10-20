querying
expectsToGetValueFor: aField
	"Are we constrained to a field which is presumably going to get a value, which for the moment must mean it's a serial type. This is primarily required for identity column databases, because in other cases we will pre-allocate sequence numbers, and this should never come up"
	| wrapper innerWrappers testBlock containing |
	wrapper := self wrapperAt: aField ifAbsent: [^false].
	innerWrappers := wrapper allInnerWrappers.
	testBlock := [:eachField | (eachField ~~ aField and: [eachField type isSerial]) ifTrue: [^true]].
	(Array with: wrapper), innerWrappers do: [:eachWrapper |
		containing := eachWrapper containedBy.
		containing glorpIsCollection 
			ifTrue: [containing keysDo: testBlock]
			ifFalse: [testBlock value: containing key]].
	^false.