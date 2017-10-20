accessing
conditionalFieldMapping: aMapping
	"This is a write-only mapping for the conditional field value, which writes out the result of performing the conditional method"
	conditionalFieldMapping := aMapping.
	descriptor isNil ifFalse: [aMapping descriptor: descriptor].
	(descriptor mappings includes: aMapping) ifTrue: [self error: 'Mapping is part of a conditional and part of the main descriptor. Be sure to send newMapping: to the conditional, not to the descriptor']