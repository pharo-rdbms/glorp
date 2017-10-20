descriptors/bank
descriptorForGlorpBankAccountNumber: aDescriptor

	| table |
	table := self tableNamed: 'BANK_ACCT'.
	aDescriptor table: table.
"	aDescriptor addMapping: ((DirectMapping from: #bankCode to: (table fieldNamed: 'BANK_CODE')) type: Integer)."
	(aDescriptor newMapping: DirectMapping) from: #bankCode to: (table fieldNamed: 'BANK_CODE').
	(aDescriptor newMapping: DirectMapping) from: #branchNumber to: (table fieldNamed: 'BRANCH_NO').
	(aDescriptor newMapping: DirectMapping) from: #accountNumber to: (table fieldNamed: 'ACCT_NO').