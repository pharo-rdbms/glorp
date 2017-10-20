obsolete
printPrimaryKeyConstraintsOn: sqlStatementStream for: aTable 
	"This method print the constraint specification on sqlStatementStream"

	aTable primaryKeyFields isEmpty ifTrue: [^self].
	(self createPrimaryKeyConstraintAddStatement: aTable primaryKeyConstraints)
		do: [ :each | sqlStatementStream nextPutAll: each].