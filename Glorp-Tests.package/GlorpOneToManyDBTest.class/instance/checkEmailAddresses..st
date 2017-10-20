support
checkEmailAddresses: emailAddresses
	| sorted numberOfAddresses |
	numberOfAddresses := (emailId1 isNil ifTrue: [0] ifFalse: [1]) + (emailId2 isNil ifTrue: [0] ifFalse: [1]) + (emailId3 isNil ifTrue: [0] ifFalse: [1]).
	self assert: emailAddresses size = numberOfAddresses.
	sorted := emailAddresses asSortedCollection: [:a :b | a id <= b id].
	emailId1 isNil ifFalse: [self assert: sorted first id = emailId1].
	emailId2 isNil ifFalse: [self assert: (sorted at: 2) id = emailId2].
	emailId3 isNil ifFalse: [self assert: sorted last id = emailId3].
	self assert: (emailAddresses collect: [:each | each id]) asSet size = emailAddresses size.