private/registering
shallowCopyOf: anObject ifNotNeeded: aBlock

	| copy |
	copy := anObject shallowCopy.
	^copy == anObject 
		ifTrue: [aBlock value]
		ifFalse: [copy]