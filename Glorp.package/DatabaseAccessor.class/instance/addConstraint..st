executing
addConstraint: aConstraint 
	
	^self 
		addConstraint: aConstraint
		ifError: [ :ex | 	| msg|
				msg := ex messageText.
				msg isEmpty ifTrue: [msg := 'No error message provided for top level exception.'].
				Transcript cr; show: ('Add constraint <1s> ERROR: (<2s>) ' expandMacrosWith: aConstraint name with: msg).
				ex return: nil].