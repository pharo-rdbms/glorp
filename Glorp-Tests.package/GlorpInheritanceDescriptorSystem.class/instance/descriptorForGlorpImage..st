as yet unclassified
descriptorForGlorpImage: aDescriptor 
	| table |
	table := self tableNamed: 'GLORP_IMAGE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'id').
	(aDescriptor newMapping: DirectMapping)
		from: #location
		to: (table fieldNamed: 'location').
	(aDescriptor newMapping: ManyToManyMapping) attributeName: #tags;
		 referenceClass: GlorpTag;
		
		join: (Join
				from: (table fieldNamed: 'id')
				to: ((self tableNamed: 'IMAGETAGS')
						fieldNamed: 'obj_id')).
	(self typeResolverFor: GlorpTaggableObject)
		register: aDescriptor