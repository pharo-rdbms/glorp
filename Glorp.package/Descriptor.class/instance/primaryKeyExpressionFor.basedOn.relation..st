mapping
primaryKeyExpressionFor: anObject basedOn: anExpression relation: aSymbol
	"anObject can be either a real domain object, or a constant expression containing it, or an expression representing the object"

	| expression value pkMappings |
	value := anObject isGlorpExpression
		ifTrue:
			[anObject isConstantExpression ifTrue: [anObject value] ifFalse: [anObject]]
		ifFalse:
			[anObject class == self describedClass
				ifFalse: [self error: 'Wrong descriptor for this object'].
			anObject].
	self isForAssociation ifTrue: [
		"We just rewrite as self value = x"
		^((anExpression get: #value) get: aSymbol withArguments: (Array with:  value)) rewriteEquality].
	expression := nil.
	pkMappings := self primaryKeyMappings.
	(pkMappings isEmpty ifTrue: [self mappings] ifFalse: [pkMappings])
		do:
			[:each | 
			| clause |
			clause := each
				expressionFor: value
				basedOn: anExpression
				relation: aSymbol.
			expression := aSymbol = #<> ifTrue: [clause OR: expression] ifFalse: [clause AND: expression]].
	^expression