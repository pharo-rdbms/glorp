building objects
objectBuilderFor: anExpression 
	"Return the builder for this expression, but only those that directly build compound objects. Most importantly, exclude dictionary builders"
	^builders detect: [:each | 
		each buildsObjects and: [each expression == anExpression]] ifNone: [nil]