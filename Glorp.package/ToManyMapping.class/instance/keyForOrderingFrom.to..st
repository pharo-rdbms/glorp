mapping
keyForOrderingFrom: anObject to: target
	self usesLinkTable ifFalse: [^target].
	^self orderField table == self linkTable ifTrue: [target] ifFalse: [anObject]