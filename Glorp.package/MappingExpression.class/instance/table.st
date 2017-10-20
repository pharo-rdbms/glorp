accessing
table
	self hasDescriptor ifTrue: [^self descriptor primaryTable].
	^self field table.