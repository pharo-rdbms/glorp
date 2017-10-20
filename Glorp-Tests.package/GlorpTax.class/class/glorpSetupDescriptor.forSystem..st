as yet unclassified
glorpSetupDescriptor: aDescriptor forSystem: aSystem
	| table |
	table := aSystem tableNamed: 'TAX'.
	aDescriptor table: table.

	"(aSystem typeResolverFor: GlorpTax)
		register: aDescriptor
		keyedBy: 'XXX'
		field: (table fieldNamed: 'TYPE')."

	(aSystem typeResolverFor: GlorpTax)
		register: aDescriptor
		abstract: true