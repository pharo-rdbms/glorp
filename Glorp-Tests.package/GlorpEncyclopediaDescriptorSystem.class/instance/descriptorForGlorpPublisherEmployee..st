descriptors
descriptorForGlorpPublisherEmployee: aDescriptor 
	| table |
	table := self tableNamed: 'PUBLISHER_EMP'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name
		to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: DirectMapping) from: #jobTitle
		to: (table fieldNamed: 'JOBTITLE').