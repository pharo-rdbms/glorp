descriptors/bank
descriptorForGlorpBankAccount: aDescriptor 

	| table |
	table := self tableNamed: 'BANK_ACCT'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id
				to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: ToManyMapping)
				attributeName: #accountHolders;
				useLinkTable.
	(aDescriptor newMapping: EmbeddedValueOneToOneMapping)
				attributeName: #accountNumber.