descriptors/employees
descriptorForGlorpRegionalManager: aDescriptor
	| table |
	table := self tableNamed: 'EMPLOYEE'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping: (DirectMapping from: #branch to: (table fieldNamed: 'BRANCH')).
	aDescriptor addMapping: (DirectMapping from: #region to: (table fieldNamed: 'REGION')).
	(self typeResolverFor: GlorpEmployee) register: aDescriptor keyedBy: 'R' field: (table fieldNamed: 'EMPLOYEE_TYPE').
	^aDescriptor