converting
inverseJoin
	"We assume that only the parts that are actually joins ought to invert"
	| new |
	new := self asGlorpExpressionOn: BaseExpression new.
	new do: [:each |
		each replaceJoinsWithInverse].
	^new.