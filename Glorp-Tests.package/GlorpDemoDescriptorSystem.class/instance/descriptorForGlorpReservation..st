descriptors/airline
descriptorForGlorpReservation: aDescriptor 
	| table |
	table := self tableNamed: 'RESERVATION'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	"The res->passenger relationship is actually 1-1, but map it as both 1-1 and 1-many so that we can more easily verify that only one object comes back, i.e. that joins are being done correctly"
	(aDescriptor newMapping: OneToManyMapping)
			attributeName: #passengers.
	(aDescriptor newMapping: OneToOneMapping)
			attributeName: #passenger.