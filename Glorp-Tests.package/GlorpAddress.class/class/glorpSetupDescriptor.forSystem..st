as yet unclassified
glorpSetupDescriptor: aDescriptor forSystem: aDescriptorSystem 
	| table |
	table := aDescriptorSystem tableNamed: 'GR_ADDRESS'.
	aDescriptor table: table.
	aDescriptor
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID'));
		addMapping: (DirectMapping from: #street to: (table fieldNamed: 'STREET'));
		addMapping: (DirectMapping from: #number to: (table fieldNamed: 'HOUSE_NUM'))