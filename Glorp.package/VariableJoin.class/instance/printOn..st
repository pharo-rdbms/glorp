printing
printOn: aStream
	[aStream query] on: Error do: [:ex | ^super printOn: aStream].
	(joins at: aStream query resultClass) printOn: aStream.