descriptors
descriptorForGlorpThingOne: aDescriptor 
	aDescriptor table: self thingOneTable.
	aDescriptor addMapping: (DirectMapping from: #id to: (self thingOneTable fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (self thingOneTable fieldNamed: 'NAME')).