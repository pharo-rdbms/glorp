descriptors/bank
descriptorForGlorpEmailAddress: aDescriptor

	| table |
	table := self tableNamed: 'EMAIL_ADDRESS'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #user to: (table fieldNamed: 'USER_NAME').
	(aDescriptor newMapping: DirectMapping) from: #host to: (table fieldNamed: 'HOST_NAME').