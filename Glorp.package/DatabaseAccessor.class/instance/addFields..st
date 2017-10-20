executing
addFields: aCollection 

	self 
		addFields: aCollection 
		ifError: [ :ex  | 	| msg |
				msg := ex messageText.
				msg isEmpty ifTrue: [msg := 'No error message provided for top level exception.'].
				Transcript cr; show: ('Add field ERROR: (<2s>) ' expandMacrosWith: msg).
				ex return: nil]