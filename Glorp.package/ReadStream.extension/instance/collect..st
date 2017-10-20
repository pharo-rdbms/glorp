*Glorp
collect: aBlock
	| newStream |
	newStream := collection species new writeStream.
	[self atEnd] whileFalse: [newStream nextPut: (aBlock value: self next)].
	^newStream contents

"Use #writeStream, not WriteStream on: collection species, for portability;  VA cannot stream over all AdditiveSequenceableCollections."