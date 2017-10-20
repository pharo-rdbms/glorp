executing
dropConstraint: aConstraint 
	
	^self 
		dropConstraint: aConstraint 
		ifError:  [ :ex | 	| msg|
				msg := ex messageText.
				msg isEmpty ifTrue: [msg := 'no error message provided for top level exception'].
				Transcript cr; show: ('Drop constraint <1s> ERROR: (<2s>'  expandMacrosWith: aConstraint name with: msg).
				ex return: nil].