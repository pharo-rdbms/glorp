as yet unclassified
glorpSetupDescriptor: aDescriptor forSystem: aSystem
	| table |
	table := aSystem tableNamed: 'TAX'.
	self glorpCommonSetupDescriptor: aDescriptor forSystem: aSystem.
	(aSystem typeResolverFor: GlorpTax)
		register: aDescriptor
		keyedBy: 'S'
		field: (table fieldNamed: 'TYPE').