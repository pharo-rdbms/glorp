converting
isConstant: aTarget
	"The target can be either a constant (which gets turned into a ConstantExpression) or (usually) a DatabaseField, representing a parameter to the query"
	(aTarget class == DatabaseField) ifTrue: [^false].
	(aTarget isGlorpExpression and: [aTarget isConstantExpression not]) ifTrue: [^false].
	^true