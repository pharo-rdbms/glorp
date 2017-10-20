private/expressions
expressionFromLinkToReferenceTableWithBase: base

	| reverse |
	reverse := self reverseJoin asGlorpExpressionOn: base.
	^reverse asGeneralGlorpExpressionWithFields.