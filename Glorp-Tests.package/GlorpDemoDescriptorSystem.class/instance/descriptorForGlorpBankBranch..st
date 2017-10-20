descriptors/bank
descriptorForGlorpBankBranch: aDescriptor

	| table distinctBranchNumber mapping |
	table := self tableNamed: 'BANK_ACCT'.
	aDescriptor table: table.
	distinctBranchNumber := [:each | ((each getTable: table) getField: (table fieldNamed: 'BRANCH_NO')) distinct] asGlorpExpression.
	mapping := aDescriptor newMapping: DirectMapping.
	mapping from: #branchNumber to: distinctBranchNumber.
	mapping readOnly: true.

	aDescriptor keyFields: (Array with: distinctBranchNumber).

	(aDescriptor newMapping: ToManyMapping)
		attributeName: #accounts;
		readOnly: true;
		join: 
						(Join
								from: distinctBranchNumber
								to: (table fieldNamed: 'BRANCH_NO')).