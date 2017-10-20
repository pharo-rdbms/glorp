types
typeWithDatabaseName: aString characterWidth: aNumber
	"Since this is SQLite, let the type names be more flexible."

	| aTypeName total block |
	block := [:sum :name | sum + (aString asLowercase findString: name startingAt: 1)].
	aTypeName := aString.
	total := #('char' 'clob' 'text') inject: 0 into: block.
	total > 0
		ifTrue: [aTypeName := 'text']
		ifFalse: 
			[total := #('num' 'double' 'float') inject: 0 into: block.
			total > 0
				ifTrue: [aTypeName := 'numeric']
				ifFalse: 
					[total := #('int') inject: 0 into: block.
					total > 0
						ifTrue: [aTypeName := 'integer']
						ifFalse: 
							[total := #('blob') inject: 0 into: block.
							total > 0 ifTrue: [aTypeName := 'blob']]]].
	aString isEmpty ifTrue: [aTypeName := 'blob'].
	^super typeWithDatabaseName: aTypeName characterWidth: aNumber