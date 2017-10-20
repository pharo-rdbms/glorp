executing
dropTables: anArray 
	anArray do: [:eachTable |
				eachTable foreignKeyConstraints 
					do: [:eachConstraint | self dropConstraint: eachConstraint ifError: [nil]]].

	anArray do: [:each | 
				self dropTableDefinition: each 
					ifError: [ :ex | 	| msg|
							msg := ex messageText.
							msg isEmpty ifTrue: [msg := 'no error message provided for top level exception'].
							Transcript cr; show: 'ERROR : (', msg, ' )'.
							ex return: nil]].