internal
anySatisfyDefault: anExpression 
	^(self system isNil or: [self system useJoinsForAnySatisfy])
		ifTrue: [self anySatisfyJoin: anExpression]
		ifFalse: [self anySatisfyExists: anExpression].