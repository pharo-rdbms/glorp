initialize
in: anExpression

	^RelationExpression named: #IN basedOn: self withArguments: (Array with: anExpression).