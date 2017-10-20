descriptors/employees
descriptorForGlorpLineWorker: aDescriptor
	| table |
	table := self tableNamed: 'EMPLOYEE'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	(self typeResolverFor: GlorpEmployee) register: aDescriptor keyedBy: 'W' field: (table fieldNamed: 'EMPLOYEE_TYPE').
	aDescriptor addMapping: (DirectMapping from: #productionLine to: (table fieldNamed: 'PRODUCTION_LINE')).
	^aDescriptor