accessing
wrapperAt: aField ifAbsent: aBlock

	| thing |
	contents isNil ifTrue: [^aBlock value].
	thing := contents at: aField position.
	^thing == self class emptySlot ifTrue: aBlock ifFalse: [thing].