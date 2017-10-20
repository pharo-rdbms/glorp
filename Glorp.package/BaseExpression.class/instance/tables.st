accessing
tables

	^self descriptor isNil ifTrue: [#()] ifFalse: [self descriptor tables].