descriptors/bank
descriptorForGlorpBankTransaction: aDescriptor
	| table | 
	table := self tableNamed: 'BANK_TRANS'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id
				to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: OneToOneMapping)
				attributeName: #owner.
	(aDescriptor newMapping: EmbeddedValueOneToOneMapping)
				attributeName: #amount;
				fieldTranslation: ((Join new)
							addSource: (table fieldNamed: 'AMT_AMT')
								target: ((self tableNamed: 'MONEY_IMAGINARY_TABLE') fieldNamed: 'AMOUNT');
							addSource: (table fieldNamed: 'AMT_CURR')
								target: ((self tableNamed: 'MONEY_IMAGINARY_TABLE') fieldNamed: 'CURRENCY');
							yourself).
	(aDescriptor newMapping: EmbeddedValueOneToOneMapping)
				attributeName: #serviceCharge.