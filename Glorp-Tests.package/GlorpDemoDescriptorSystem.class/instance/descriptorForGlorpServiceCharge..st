descriptors/bank
descriptorForGlorpServiceCharge: aDescriptor 
	
	| table |
	table := self tableNamed: 'BANK_TRANS'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #description
				to: (table fieldNamed: 'SRVC_DESC').
	(aDescriptor newMapping: EmbeddedValueOneToOneMapping)
				attributeName: #amount;
				fieldTranslation: ((Join new)
							addSource: (table fieldNamed: 'SRVC_AMT_AMT')
								target: ((self tableNamed: 'MONEY_IMAGINARY_TABLE') fieldNamed: 'AMOUNT');
							addSource: (table fieldNamed: 'SRVC_AMT_CURR')
								target: ((self tableNamed: 'MONEY_IMAGINARY_TABLE') fieldNamed: 'CURRENCY');
							yourself).