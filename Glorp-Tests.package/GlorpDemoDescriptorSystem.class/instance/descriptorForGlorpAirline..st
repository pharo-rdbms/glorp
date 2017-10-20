descriptors/airline
descriptorForGlorpAirline: aDescriptor 
	aDescriptor table: (self tableNamed: 'AIRLINE').
	aDescriptor directMappingFor: #id.
	aDescriptor directMappingFor: #name.