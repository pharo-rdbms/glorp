executing
alterFieldDropDefault: aField

	self 
		alterFieldDropDefault: aField 
		ifError: [ :ex | 	| msg|
				msg := ex messageText.
				msg isEmpty ifTrue: [msg := 'No error message provided for top level exception.'].
				Transcript cr; show: ('Alter column  <1s> to drop default ERROR: (<2s>) ' expandMacrosWith: aField name  with: msg).
				ex return: nil].