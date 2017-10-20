reporting
tables
	^query isNil ifTrue: [Array with: #Unknown] ifFalse: [super tables].