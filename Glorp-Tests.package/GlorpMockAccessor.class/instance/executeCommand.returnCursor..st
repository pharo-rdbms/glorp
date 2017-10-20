executing
executeCommand: aCommand returnCursor: aBoolean
	| result |
	result := #(#(3)).
	^aBoolean ifTrue: [result readStream] ifFalse: [result].