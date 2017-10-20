sequencing
shouldGenerateValueFor: aField in: aSession
	| isInsert |
	aField isGenerated ifFalse: [^false].
	aField type generatesOverExistingValues ifTrue: [^true].
	"For those that don't write over existing values, only update them if this is an insert. Otherwise we can't tell the difference between an empty column and one which we're just not updating in this unit of work. This requires the session, but the session may be nil - if so, default to true, because that usage is just for reserving sequence numbers, and it's better to err on the side of too many."
	isInsert := aSession isNil ifTrue: [true] ifFalse: [aSession shouldInsert: self].
	^isInsert and: [(self hasValueFor: aField) not].