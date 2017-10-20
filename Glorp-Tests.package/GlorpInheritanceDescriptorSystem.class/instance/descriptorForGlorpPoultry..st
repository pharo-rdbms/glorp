descriptors/employees
descriptorForGlorpPoultry: aDescriptor
	"Poultry does not participate in the InventoryItem heirarchy (ie it will not be retrieved when asking for an InventoryItem)"
	| table |
	table := self tableNamed: 'POULTRY'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping: (DirectMapping from: #age to: (table fieldNamed: 'AGE')).
	aDescriptor addMapping: (DirectMapping from: #featherColor to: (table fieldNamed: 'FEATHER_COLOR')).
	^aDescriptor