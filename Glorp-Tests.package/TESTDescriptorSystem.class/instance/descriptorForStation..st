descriptors
descriptorForStation: aDescriptor

	| table1 |
	table1 := self tableNamed: 'NOTIFIER_STATION'.
	aDescriptor table: table1.
	(self typeResolverFor: Station) register: aDescriptor abstract: true.