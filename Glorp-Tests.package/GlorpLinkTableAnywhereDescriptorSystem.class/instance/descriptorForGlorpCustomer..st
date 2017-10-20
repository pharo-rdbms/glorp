descriptors/bank
descriptorForGlorpCustomer: aDescriptor

	| table |
	table := self tableNamed: 'GR_CUSTOMER'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: OneToManyMapping)
			attributeName: #transactions;
			referenceClass: GlorpBankTransaction.
	(aDescriptor newMapping: OneToOneMapping)
			attributeName: #accounts;
			referenceClass: GlorpBankAccount;
			usesLinkTable: true.