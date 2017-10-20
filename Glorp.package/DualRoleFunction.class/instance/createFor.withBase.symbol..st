copying
createFor: argumentList withBase: anExpression symbol: aSymbol
	| new newBase newArgument newFunction |
	new := super createFor: argumentList withBase: anExpression symbol: aSymbol.
	"For the where clause version, we've got a dualRoleFunction. We can't just rebuild the whole thing, so rebuild the children, and then re-assemble it recreating from the template."
	newBase := new whereClauseVersion base isNil ifTrue: [anExpression] ifFalse: [new whereClauseVersion base rebuildOn: anExpression].
	newArgument := new whereClauseVersion argument rebuildOn: anExpression.
	newFunction := self whereClauseVersion copy.
	newFunction symbol: aSymbol.
	newFunction base: newBase.
	newFunction argument: newArgument.
	new whereClauseVersion: newFunction.
	"Don't try to rebuild the selectListVersion at all, because at least for the motivating case we have, it's just a shell, not a full blown expression, and it will already have been copied."
	^new.