preparing
rewriteEquality
	| keyEquality descriptor describedClass |
	leftChild := leftChild rewriteBooleanEquality: relation.
	leftChild hasDescriptor ifFalse: [^self].
	"A slightly convoluted way of checking if this is a pseudo-descriptor for a primitive type used in something like a DirectToManyMapping, in which case we can't rewrite. But if it's a pseudo-descriptor for a dictionary mapping where we actually use the mapping as the key rather than a class, then we're ok. It'd be nice if the code for this were more expressive."
	descriptor := leftChild descriptor.
	describedClass := descriptor describedClass.
	(describedClass ~~ Association and: [(descriptor session descriptorFor: describedClass) isNil]) ifTrue: [^self].

	(relation = #= | (relation = #<>) | (relation = #IN)) ifFalse: [^self].
	(relation = #IN and: [leftChild descriptor primaryTable primaryKeyFields size > 1]) ifTrue: [
		(GlorpInvalidExpressionError signal: 'Cannot convert an object comparison to an IN comparison when the table uses a composite primary key')].
	keyEquality := leftChild descriptor
		primaryKeyExpressionFor: rightChild
		basedOn: leftChild
		relation: relation.
	^keyEquality.