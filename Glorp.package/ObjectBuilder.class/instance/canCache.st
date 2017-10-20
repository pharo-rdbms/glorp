building objects
canCache
	| keyFields |
	keyFields := self descriptor keyFields.
	^keyFields notNil and: [keyFields notEmpty]