executing
alterFieldDropNotNull: aField

	self 
		alterFieldDropNotNull: aField 
		ifError: [ :ex | 	| msg|
				msg := ex messageText.
				msg isEmpty ifTrue: [msg := 'No error message provided for top level exception.'].
				Transcript cr; show: ('Alter column  <1s> to drop not null ERROR: (<2s>) ' expandMacrosWith: aField name  with: msg).
				ex return: nil].