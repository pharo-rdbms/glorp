conditions
if: conditionSelector then: aMapping

	cases add: (Association key: conditionSelector value: aMapping).
	descriptor isNil ifFalse: [aMapping descriptor: descriptor].
	(descriptor mappings includes: aMapping) ifTrue: [self error: 'Mapping is part of a conditional and part of the main descriptor. Be sure to send newMapping: to the conditional, not to the descriptor']