executing
alterField: aField setDefault: aType

	self 
		alterField: aField 
		setDefault: aType 
		ifError: [ :ex | 	| msg|
				msg := ex messageText.
				msg isEmpty ifTrue: [msg := 'No error message provided for top level exception.'].
				Transcript cr; show: ('Alter column  <1s> to set default <2s>  ERROR: (<2s>) ' expandMacrosWith: aField name with: aType sqlString with: msg).
				ex return: nil].