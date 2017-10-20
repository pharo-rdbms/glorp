descriptors/other
descriptorForGlorpTransformedTime: aDescriptor 
	| table timeField |
	table := self tableNamed: 'TRANSFORMED_TIME'.
	aDescriptor 
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	timeField := table fieldNamed: 'TIMEFIELD'.
	aDescriptor table: table.
	aDescriptor addMapping: (AdHocMapping 
				forAttribute: #time
				fromDb: 
					[:row :elementBuilder :context| 
					Time fromSeconds: (elementBuilder valueOfField: (context translateField: timeField) in: row) ]
				toDb: 
					[:rows :attribute :attributeRows | 
					(rows at: table) at: timeField put: attribute asSeconds]
				mappingFields: (Array with: timeField)).
	"Note that position won't work if we have a join. We need to take the elementbuilder into account"
	^aDescriptor