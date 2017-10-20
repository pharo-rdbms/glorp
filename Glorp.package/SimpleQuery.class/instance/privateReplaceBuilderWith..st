private
privateReplaceBuilderWith: anElementBuilder

	| oldBuilder |
	oldBuilder := self elementBuilderFor: anElementBuilder expression.
	oldBuilder isNil ifTrue: [self error: 'No builder found to replace.'].
	builders at: (builders indexOf: oldBuilder) put: anElementBuilder