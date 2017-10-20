descriptors/airline
descriptorForGlorpItinerary: aDescriptor 
	aDescriptor table: (self tableNamed: 'ITINERARY').
	aDescriptor directMappingFor: #id.
	(aDescriptor newMapping: OneToOneMapping)
			attributeName: #reservation.