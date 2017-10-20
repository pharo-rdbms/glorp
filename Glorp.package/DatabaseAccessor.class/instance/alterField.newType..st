executing
alterField: aField newType: aType 

	^self 
		alterField: aField 
		newType: aType 
		ifError: [ :ex | 	| msg|
				msg := ex messageText.
				msg isEmpty ifTrue: [msg := 'No error message provided for top level exception.'].
				Transcript cr; show: ('Alter column <1s> to set new type <2s> ERROR: (<3s>) ' expandMacrosWith: aField name with: aType sqlString with: msg).
				ex return: nil].