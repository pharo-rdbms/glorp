accessing
descriptorForASOrder: aDescriptor
	| table newMapping join |
	table := self tableNamed: 'ASORDER'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #orderNo
		to: (table fieldNamed: 'ORDERNO').
	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #lineItems.
	newMapping := aDescriptor newMapping: OneToOneMapping.
	newMapping attributeName: #customer.
	join := Join new.
	join
		from: (table fieldNamed: 'CUSTOMERID')
		to: ((self tableNamed: 'ASCUSTOMER') fieldNamed: 'ID').
	newMapping join: join.