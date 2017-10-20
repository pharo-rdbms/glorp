support
checkAccounts

	| sorted numberOfAccounts |
	numberOfAccounts := (accountId1 isNil ifTrue: [0] ifFalse: [1]) + (accountId2 isNil ifTrue: [0] ifFalse: [1]) + (accountId3 isNil ifTrue: [0] ifFalse: [1]).
	self assert: customer accounts size = numberOfAccounts.
	sorted := customer accounts asSortedCollection: [:a :b | a id <= b id].
	accountId1 isNil ifFalse: [self assert: sorted first id = accountId1].
	accountId2 isNil ifFalse: [self assert: (sorted at: 2) id = accountId2].
	accountId3 isNil ifFalse: [self assert: sorted last id = accountId3].
	self assert: (customer accounts collect: [:each | each id]) asSet size = customer accounts size.