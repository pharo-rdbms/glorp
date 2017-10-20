accessing
join: aJoin
	"We allow the join to be specified either as a Join (the normal case) or as an expression. We expect an expression specifying the relationship in terms of other relationships. So, e.g. to specify the join from InsurancePlan to PolicyHolder we might specify
[:eachPolicyHolder | eachPolicyHolder employer availablePlans].  Note that the relationship is described from the point of view of the target, and is just a list of mappings. Then we take this internally and transform it into an equality expression we can use to define the relationship."
	| base basicExpression |
	(Dialect isBlock: aJoin) 
		ifTrue: [
			self beReadOnly.
			base := JoinBaseExpression new.
			base descriptor: (self system descriptorFor: self referenceClass).
			basicExpression := aJoin asGlorpExpressionOn: base.
			"It doesn't matter what name we give the parameter, because it will be rewritten into a primary key comparison anyway, that will use the fields as 'names'. Also, it's important that we assign into join here, because otherwise the rewriteEquality operation will try and figure out a join for us, since it's still nil."
			join := basicExpression get: #= withArguments: (
				Array with: (ParameterExpression forField: 'sourceObject' basedOn: basicExpression join)).
			join := join rewriteEquality]
		ifFalse: [join := aJoin].
	[join owningMapping: self] on: MessageNotUnderstood do: [:ex | ex | ex return].