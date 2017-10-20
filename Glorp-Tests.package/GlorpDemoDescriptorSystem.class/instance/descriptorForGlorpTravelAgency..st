descriptors/airline
descriptorForGlorpTravelAgency: aDescriptor
	| table |
	table := self tableNamed: 'GR_TRAVEL_AGENT'.
	aDescriptor table: table.
	aDescriptor directMapping from: #name to: (table fieldNamed: 'AGENCY_NAME').
	aDescriptor toManyMapping
			attributeName: #agents;
			join: (Join from: (table fieldNamed: 'AGENCY_NAME') to: (table fieldNamed: 'AGENCY_NAME')).