converting
onlyJoinParts
	"Strip out any generic parts, leaving only the things that are actually joins"
	| new |
	new := self asGlorpExpressionOn: BaseExpression new.
	new do: [:each |
		each removeNonJoinParts].
	new := new condenseBooleanEquality.
	new isJoin ifFalse: [new do: [:each | each condenseBooleanEqualityExpressions]].
	^new.