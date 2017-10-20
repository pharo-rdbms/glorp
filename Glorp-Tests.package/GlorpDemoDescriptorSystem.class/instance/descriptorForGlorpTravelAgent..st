descriptors/airline
descriptorForGlorpTravelAgent: aDescriptor
	| table |
	table := self tableNamed: 'GR_TRAVEL_AGENT'.
	aDescriptor table: table.
	aDescriptor directMapping from: #id to: (table fieldNamed: 'ID').
	aDescriptor directMapping from: #name to: (table fieldNamed: 'AGENT_NAME').
	(aDescriptor newMapping: EmbeddedValueOneToOneMapping)
			attributeName: #agency.