transformations
transformationExpression

	^self hasFieldTranslation
		ifTrue: [fieldTranslation]
		ifFalse: [fieldTranslation := self defaultTransformationExpressionFor: (self referenceDescriptor)].