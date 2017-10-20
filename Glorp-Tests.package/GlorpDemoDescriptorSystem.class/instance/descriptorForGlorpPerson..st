descriptors/bank
descriptorForGlorpPerson: aDescriptor

	| table |
	table := self tableNamed: 'PERSON'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: DirectMapping) fromPseudoVariable: #addressId to: (table fieldNamed: 'ADDRESS_ID').
	(aDescriptor newMapping: OneToOneMapping)
			attributeName: #address.
	(aDescriptor newMapping: ToManyMapping)
			attributeName: #emailAddresses;
			orderBy: #id.