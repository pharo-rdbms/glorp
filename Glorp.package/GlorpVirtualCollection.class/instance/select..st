enumerating
select: aBlock
	^self isInstantiated ifTrue: [self realObjects select: aBlock] ifFalse: [self copy AND: aBlock]