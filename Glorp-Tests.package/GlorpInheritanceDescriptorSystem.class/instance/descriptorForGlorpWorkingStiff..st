descriptors/employees
descriptorForGlorpWorkingStiff: aDescriptor
	"Working stiff does not participate in the Employee type mapping scheme (it uses its own table)"
	| table |
	table := self tableNamed: 'WORKING_STIFF'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	^aDescriptor