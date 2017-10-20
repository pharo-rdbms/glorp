preparing
condensePrimaryKeyComparison
	"This tries to condense expressions of the form
         something relatedObject id = x
      with 
          something foreignKeyToRelatedObjectId = x, saving a join (and making the thing work at all, in the case where x = nil"

	| fieldBeingCompared baseObjectExpression join sourceField |
	(relation = #= or: [relation = #<>]) ifFalse: [^self].
	self leftChild mappedFields size = 1 ifFalse: [^self].
	fieldBeingCompared := self leftChild field.
	fieldBeingCompared class == DatabaseField ifFalse: [^self].
	fieldBeingCompared isPrimaryKey ifFalse: [^self].
	baseObjectExpression := self leftChild base.
	baseObjectExpression representsDerivedObject ifFalse: [^self].
	"If we have an expression for a join, don't even try."
	baseObjectExpression join isJoin ifFalse: [^self].
	join := baseObjectExpression join asGlorpExpressionOn: baseObjectExpression base.
	sourceField := join sourceForTarget: fieldBeingCompared.
	sourceField isNil ifTrue: [^self].

	"OK, we've got a match, replace ourselves with the shortcut"
	^(sourceField isGlorpExpression and: [sourceField isConstantExpression])
		ifTrue: [self rightChild get: relation withArguments: (Array with: sourceField)]
		ifFalse: [(self leftChild base base getField: sourceField) get: relation withArguments: (Array with: self rightChild)].