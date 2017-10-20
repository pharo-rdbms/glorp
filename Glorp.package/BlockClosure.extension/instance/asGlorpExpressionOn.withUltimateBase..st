*Glorp-Core
asGlorpExpressionOn: anExpression withUltimateBase: aBaseExpression
	"Build the expression, knowing that some parts of it may refer to an outer context based on aBaseExpression. This is primarily useful for subselect blocks"
	| archiver tree |
	archiver := MessageArchiver new.
	tree := self value: archiver.
	^tree asGlorpExpressionOn: anExpression basedOn: archiver withUltimateBase: aBaseExpression.