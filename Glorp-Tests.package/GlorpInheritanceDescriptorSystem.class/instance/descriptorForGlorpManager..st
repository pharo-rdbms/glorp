descriptors/employees
descriptorForGlorpManager: aDescriptor
	| table |
	table := self tableNamed: 'EMPLOYEE'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping: (DirectMapping from: #branch to: (table fieldNamed: 'BRANCH')).
	(self typeResolverFor: GlorpEmployee) register: aDescriptor keyedBy: 'M' field: (table fieldNamed: 'EMPLOYEE_TYPE').
	^aDescriptor