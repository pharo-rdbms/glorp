descriptors/bank
descriptorForGlorpMoney: aDescriptor

	| table |
	table := self tableNamed: 'MONEY_IMAGINARY_TABLE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #currency type: Symbol to: (table fieldNamed: 'CURRENCY').
	(aDescriptor newMapping: DirectMapping) from: #amount to: (table fieldNamed: 'AMOUNT').
	^aDescriptor.