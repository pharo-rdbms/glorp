as yet unclassified
glorpCommonSetupDescriptor: aDescriptor forSystem: aSystem
	| table |
	table := aSystem tableNamed: 'TAX'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping:
			((OneToManyMapping new)
				attributeName: #taxes;
				referenceClass: GlorpTax;
				join: (Join from: (table fieldNamed: 'ID') to: (table fieldNamed: 'TAX_ID'))).
	aDescriptor addMapping:
			((OneToOneMapping new)
				attributeName: #supertax;
				referenceClass: GlorpTax;
				join: (Join from: (table fieldNamed: 'TAX_ID') to: (table fieldNamed: 'ID'))).