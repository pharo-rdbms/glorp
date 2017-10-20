tests
testElementBuilderFields
	elementBuilder fieldsForSelectStatement 
		do: [:each | self assert: each table name = 't1']