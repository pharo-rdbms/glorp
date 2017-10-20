preparing
rewriteBooleanEquality: relation
	"If we are a boolean that doesn't have a comparison relation on top of us, replace us with an ' = true'"

	"Only rewrite booleans"
	(self mapping notNil and: [self mapping attribute type = Boolean]) ifFalse: [^self].

	"See if we're already part of an equality comparison, don't rewrite twice"
	(relation = #= | (relation = #<>) | (relation = #IN)) ifTrue: [^self].
	"If we're a boolean function, we don't need or want the comparison. e.g. EXISTS. This is a bit hard to test for."
	(self mapping field isGlorpExpression and: [self mapping field field isNil]) ifTrue: [^self].

	^self get: #= withArguments: (Array with: true asGlorpExpression).