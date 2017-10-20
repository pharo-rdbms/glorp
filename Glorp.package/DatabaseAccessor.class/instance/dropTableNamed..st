executing
dropTableNamed: aString 
	self 
		dropTableNamed: aString 
		ifAbsent: [:ex | 	| msg|
				msg := ex messageText.
				msg isEmpty ifTrue: [msg := 'No error message provided for top level exception.'].
				Transcript cr; show: ('Drop table <1s> ERROR: (<2s>) ' expandMacrosWith: aString with: msg).
				ex return: nil]