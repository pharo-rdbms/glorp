accessing
keyFields
	"Return the fields we use as primary keys for caching purposes. Typically, these are just going to be the primary keys of our primary table. Objects intended to be embedded won't map the primary keys at all. Weird objects may supply their own keys (e.g. functions rather than fields directly)"

	^keyFields == nil
		ifTrue:
			[self mapsPrimaryKeys
				ifTrue: [self primaryTable primaryKeyFields]
				ifFalse: [nil]]
		ifFalse: [keyFields].