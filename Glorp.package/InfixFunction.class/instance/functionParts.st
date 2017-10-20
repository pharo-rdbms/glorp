accessing
functionParts
	functionParts isNil ifTrue: [functionParts := Array with: function].
	^functionParts.