accessing
descriptorForASOrderLineItem: aDescriptor
	| table newMapping join |
	table := self tableNamed: 'ASORDERLINEITEM'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #posNo
		to: (table fieldNamed: 'POSNO').
	(aDescriptor newMapping: DirectMapping)
		from: #quantity
		to: (table fieldNamed: 'QUANTITY').
	(aDescriptor newMapping: DirectMapping)
		from: #price
		to: (table fieldNamed: 'PRICE').

	newMapping := aDescriptor newMapping: OneToOneMapping.
	newMapping attributeName: #order.
	join := Join new.
	join
		from: (table fieldNamed: 'ORDERORDERNO')
		to: ((self tableNamed: 'ASORDER') fieldNamed: 'ORDERNO').
	newMapping join: join.

	newMapping := aDescriptor newMapping: OneToOneMapping.
	newMapping attributeName: #item.
	join := Join new.
	join
		from: (table fieldNamed: 'ITEMID')
		to: ((self tableNamed: 'ASITEM') fieldNamed: 'ID').
	newMapping join: join.