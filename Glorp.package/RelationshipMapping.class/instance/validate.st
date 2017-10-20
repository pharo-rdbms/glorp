validation
validate
	| targetJoinSourceFields targetJoinTargetTables |
	super validate.
	self join isNil ifTrue: [^self].
	targetJoinSourceFields := targetTableJoin isNil ifTrue: [#()] ifFalse: [targetTableJoin allSourceFields].
	targetJoinTargetTables :=  targetTableJoin isNil ifTrue: [#()] ifFalse: [targetTableJoin allTargetFields collect: [:each | each table]].
	(self join allSourceFields asArray, targetJoinSourceFields)
		do:
			[:each | 
			(each class == DatabaseField or: [each isKindOf: FunctionExpression]) 
				ifTrue: [(self descriptor tables includes: each table)
					ifFalse: [self error: 'Joins should go from the table(s) associated with this descriptor to the other table(s)']]].
	(self targetTables asArray, targetJoinTargetTables)
		do:
			[:each | 
			(self referenceDescriptor allTables includes: each)
				ifFalse:
					[self
						error:
							'Joins should go to the table(s) associated with the reference class of the mapping']].

	join allSourceFields asSet size = join allSourceFields size ifFalse: [self error: 'The same field occurs twice in the join. This might be legal, but is probably a cut and paste error.'].
	join allTargetFields asSet size = join allTargetFields size ifFalse: [self error: 'The same field occurs twice in the join. This might be legal, but is probably a cut and paste error.'].

	(self isExclusive and: [self canWrite not]) ifTrue: [self error: 'It is not meaningful to have an exclusive relationship that is read-only.'].