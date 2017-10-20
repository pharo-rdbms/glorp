*Glorp
select: aBlock
	| newStream |
	newStream := collection species new writeStream.
	[self atEnd] whileFalse: [
		| current |
		current := self next.
		(aBlock value: current) ifTrue: [newStream nextPut: current]].
	^newStream contents

"Use #writeStream, not WriteStream on: collection species, for portability;  VA cannot stream over all AdditiveSequenceableCollections."