mapping
applicableMappingForObject: anObject
	| conditionalValue |
	conditionalValue := self conditionalValueFor: anObject.
	^self applicableMappingForConditionalValue: conditionalValue